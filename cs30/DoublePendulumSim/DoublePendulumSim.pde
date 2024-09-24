// TODO: our liberal use of global variables is questionable
//       is there any way to improve performance?
class Node {
     Float[] data;
     Node next;
     Node prev;
     
     Node()
     {
          data = new Float[2];
          next = null;
          prev = null;
     }
}

// Custom linked list
class List {
   Node head;
   Node tail;
   int size;
   int maxSize;
   
   List(int max)
   {
        head = new Node();
        tail = head;
        maxSize = max;
        size = 1;
   }
   
   void insertAtEnd(float a, float b)
   {
        if (head == null) return;

        boolean headFilled = head.data[0] != null;
        if (!headFilled) {
             head.data[0] = a;
             head.data[1] = b;
             return;
        }

        Node n = new Node();
        n.data[0] = a;
        n.data[1] = b;

        tail.next = n;
        n.prev = tail;
        tail = n;
        size++;
   }
   
   void add(float a, float b)
   {
        insertAtEnd(a, b);
        if (size >= maxSize)
            shiftUp();
   }
   
   void shiftUp()
   {
         if (head.next == null) return;
         head.next.prev = null;
         head = head.next;
         size --;
   }
   
   void empty()
   {
        size = 1;
        head = new Node();
        tail = head;
   }
}

// Handles simulating the behaviour of a double pendulum
class DoublePendulum {
    // First pendulum
    float x1, y1;
    float angular_vel1 = 0.0; // Angular velocity
    float angular_acc1 = 0.0; // Angular acceleration
    float angle1 = PI/4;  // Angle of the rod from the origin
    float rod1 = 100; // Length of the rod 
    float mass1 = 20; // Weight of the mass 

    // Second pendulum
    float x2, y2;
    float angular_vel2 = 0;
    float angular_acc2 = 0;
    float angle2 = PI/8;
    float rod2 = 100;
    float mass2 = 20;

    float gravity = 1.0; // Gravitational constant

    List prevPositions;
    List prevAngles;

    public DoublePendulum()
    {
        prevPositions = new List(50);
        prevAngles = new List(10);
    }

    // Compound the angular accelerations to the angular velocities
    // and the angular velocities to the angles.
    // The equations of motion come from [here](https://www.myphysicslab.com/pendulum/double-pendulum-en.html).
    // The equations are slightly horrifying, but the derivation is interesting.
    void subStep(int substepCount)
    {
        float den = (2 * mass1 + mass2 - mass2 * cos(2 * angle1 - 2 * angle2));
        float a = -gravity * (2 * mass1 + mass2) * sin(angle1);
        float b = -mass2 * gravity * sin(angle1 - 2 * angle2);
        float c = -2 * sin(angle1 - angle2) * mass2;
        float d = angular_vel2 * angular_vel2 * rod2;
        float e = angular_vel1 * angular_vel1 * rod1 * cos(angle1 - angle2);
        float f = 2 * sin(angle1 - angle2);
        float g = angular_vel1 * angular_vel1 * rod1 * (mass1 + mass2);
        float h = gravity * (mass1 + mass2) * cos(angle1);
        float i = angular_vel2 * angular_vel2 * rod2 * mass2 * cos(angle1 - angle2);

        angular_acc1 = (a + b + c * (d + e)) / (rod1 * den);
        angular_vel1 += (angular_acc1 / substepCount);
        angle1  += (angular_vel1 / substepCount);
        angle1 %= (2 * PI); // Force angle to be between -PI and PI

        angular_acc2 = f * (g + h + i) / (rod2 * den);
        angular_vel2 += (angular_acc2 / substepCount);
        angle2  += (angular_vel2 / substepCount);
        angle2 %= (2 * PI); // Force angle to be between -PI and PI
    }

    void step(boolean shouldTraceAngles, int x, int y)
    {
        // Since we are using numerical methods, our simulation will be
        // prone to errors. There are analytical solutions to the double
        // pendulum problem, but as of now, even they are approximate.
        // So, we'll stick with our numerical solution, but split the
        // simulation into substeps to try to minimize error.
        // This [explanation](https://stackoverflow.com/questions/67203975/why-is-my-code-for-a-double-pendulum-returning-nan)
        // is really nice
        int substepCount = 10;
        for (int i = 0; i < substepCount; i++) {
            subStep(substepCount);
        }

        if (shouldTraceAngles) {
            prevAngles.add(angle1, angle2);
        }
    }
}

color grey = color(128, 128, 128);
color black = color(0, 0, 0);
color blue = color(0, 0, 255);
color white = color(255, 255, 255);
color orange = color(250, 143, 2);
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color rodColors[] = {grey, grey, green, blue};
color bgColors[] = {black, white, black, green};
color fillColors[] = {blue, orange, red, red};

DoublePendulum dp = new DoublePendulum();
int currentBackground = 0; // ranges from 0 to 3
boolean tracePendulumPath = false;
boolean tracePendulum = false;
boolean paused = false;

int originX = 300;
int originY = 100;

void setup()
{
    size(600, 600);
    strokeWeight(2);
}

void drawPendulumPath(DoublePendulum dp)
{
    // Draw a fading trail of lines
    int i = 0;
    for (Node n = dp.prevPositions.head.next; n != null; n = n.next) {
        float opacity = 255 / (dp.prevPositions.size - i);
        stroke(rodColors[currentBackground], opacity);
        line(n.prev.data[0], n.prev.data[1], n.data[0], n.data[1]);
        i++;
    }
}

// Draw the double pendulum (lines and masses) at the xy position
void drawDoublePendulum(DoublePendulum dp, float angle1, float angle2, float opacity)
{
    // This looks backwards, but since the angle in our triangle
    // is shooting downwards, the x value would be the
    // opposite and the y value would be the adjacent
    float x1 = originX - dp.rod1 * sin(angle1);
    float y1 = originY + dp.rod1 * cos(angle1);
    float x2 = x1 - dp.rod2 * sin(angle2);
    float y2 = y1 + dp.rod2 * cos(angle2);
    if (tracePendulumPath) {
        dp.prevPositions.add(x2, y2 + dp.mass2 / 2); 
    }

    // Draw the rods
    stroke(rodColors[currentBackground], opacity);
    line(originX, originY, x1, y1);
    line(x1, y1, x2, y2);

    // Draw the masses with no outline
    noStroke();
    fill(fillColors[currentBackground], opacity);
    ellipse(x1, y1, dp.mass1, dp.mass1);
    ellipse(x2, y2, dp.mass2, dp.mass2);
}

void drawDoublePendulumMotion(DoublePendulum dp, int x, int y)
{
    if (tracePendulumPath)
        drawPendulumPath(dp);

    if (!tracePendulum) {
        drawDoublePendulum(dp, dp.angle1, dp.angle2, 255);
        return;
    }

    // Draw a fading trail of pendulums
    int i = 0;
    for (Node n = dp.prevAngles.head; n != null; n = n.next) {
        float opacity = 255 / (dp.prevAngles.size - i);
        drawDoublePendulum(dp, n.data[0], n.data[1], opacity);
        i ++;
    }
}

void mouseReleased()
{
    // Cycle through the program state on right click
    if (mouseButton == RIGHT) {
        currentBackground = (currentBackground + 1) % 4;
        tracePendulumPath = currentBackground == 1;
        tracePendulum = currentBackground == 2;
        if (!tracePendulum) dp.prevAngles.empty();
        if (!tracePendulumPath) dp.prevPositions.empty();
    }
}

void keyReleased()
{
    // Toggle pause
    if (key == ' ')
        paused = !paused;
}

void draw()
{
    if (!paused) {
        background(bgColors[currentBackground]);
        dp.step(tracePendulum, originX, originY);
        drawDoublePendulumMotion(dp, originX, originY);
    }
}
