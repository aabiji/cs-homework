class Node {
    Float[] data;
    Node next;
    Node prev;

    Node() {
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

   List(int max) {
        head = new Node();
        tail = head;
        maxSize = max;
        size = 1;
   }

   void insertAtEnd(float a, float b) {
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

   void add(float a, float b) {
        insertAtEnd(a, b);
        if (size >= maxSize)
            shiftUp();
   }

   void shiftUp() {
        if (head.next == null) return;
        head.next.prev = null;
        head = head.next;
        size --;
   }

   void empty() {
        size = 1;
        head = new Node();
        tail = head;
   }
}

// Handles simulating the behaviour of a double pendulum
class DoublePendulum {
    // First pendulum
    float angular_vel1 = 0.0; // Angular velocity
    float angular_acc1 = 0.0; // Angular acceleration
    float angle1 = PI/4;  // Angle of the rod from the origin
    float rod1; // Length of the rod
    float mass1; // Weight of the mass

    // Second pendulum
    float angular_vel2 = 0;
    float angular_acc2 = 0;
    float angle2 = PI/8;
    float rod2;
    float mass2;

    float gravity; // Gravitational constant

    List prevPositions;
    List prevAngles;

    public DoublePendulum() {
        prevPositions = new List(65);
        prevAngles = new List(10);
    }

    // Compound the angular accelerations to the angular velocities
    // and the angular velocities to the angles.
    // The equations of motion come from [here](https://www.myphysicslab.com/pendulum/double-pendulum-en.html).
    // The equations are slightly horrifying, but the derivation is interesting.
    void subStep(int substepCount) {
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

    void step(boolean shouldTraceAngles) {
        // Since we are using numerical methods, our simulation will be
        // prone to errors. There are analytical solutions to the double
        // pendulum problem, but as of now, even they are approximate.
        // So, we'll stick with our numerical solution, but split the
        // simulation into substeps to try to minimize error.
        // This [explanation](https://stackoverflow.com/questions/67203975/why-is-my-code-for-a-double-pendulum-returning-nan)
        // is really nice
        int substepCount = 50;
        for (int i = 0; i < substepCount; i++) {
            subStep(substepCount);
        }

        if (shouldTraceAngles) {
            prevAngles.add(angle1, angle2);
        }
    }
}

// Slider UI component
class Slider {
    int x, y;
    int width;
    int rangeStart, rangeEnd;
    int value;
    String name;

    Slider(String id, int initial, int xpos, int ypos, int dragWidth, int start, int end) {
        x = xpos;
        y = ypos;
        width = dragWidth;
        rangeStart = start;
        rangeEnd = end;
        value = initial;
        name = id;
    }

    void draw() {
        stroke(strokeColors[currentBackground]);
        fill(fillColors[currentBackground]);

        int valueHeight = 20;
        textSize(valueHeight);
        String formatted = String.format("%d", value);
        float valueWidth = textWidth(formatted);
        text(formatted, x - valueWidth * 1.5, y + valueHeight / 3);

        valueWidth = textWidth(name);
        text(name, x + width - valueWidth, y - valueHeight);

        strokeWeight(4);
        line(x, y, x + width, y);
        noStroke();
        float dragX = map(value, rangeStart, rangeEnd, 0, width);
        ellipse(x + dragX, y, 10, 10);
        strokeWeight(2);
    }

    void handleDrag() {
        int padding = 30;
        if (mouseY < y - (padding / 2) || mouseY > y + (padding / 2))
            return; // Only drag when on the slider
        int xpos = max(x, min(mouseX, x + width));
        value = (int)map(xpos - x, 0, width, rangeStart, rangeEnd);
    }
}

Slider gravitySlider = new Slider("Gravity", 1, 100, 100, 80, 0, 10);
Slider rodSlider1 = new Slider("Rod #1", 100, 80, 180, 100, 100, 250);
Slider rodSlider2 = new Slider("Rod #2", 100, 80, 260, 100, 100, 250);
Slider massSlider1 = new Slider("Mass #1", 20, 80, 340, 100, 10, 50);
Slider massSlider2 = new Slider("Mass #2", 20, 80, 420, 100, 10, 50);

color bgColors[]     = {color(255, 255, 255), color(255, 255, 255), color(0, 0, 0),   color(19, 41, 61)};
color fillColors[]   = {color(34, 34, 34),    color(255, 104, 107), color(255, 0, 0), color(27, 152, 224)};
color strokeColors[] = {color(75, 78, 109),   color(49, 175, 144),  color(0, 255, 0), color(0, 100, 148)};

int textY = 550;
int objectsDirection = 1, copyrightDirection = 1;
int objectX = 400, copyrightX = 200;
int objectsWidth = -1, copyrightWidth = -1;
String copyright[] = {"© Abigail Adegbiji", "September 26, 2024"};
String objectNames[] = {"Gravity slider", "Rod #1", "Rod #1 slider", "Rod #2", "Rod #2 slider", "Mass #1", "Mass #1 slider", "Mass #2", "Mass #2 slider"};

DoublePendulum dp = new DoublePendulum();
int currentBackground = 0; // ranges from 0 to 3
boolean tracePendulumPath = false;
boolean tracePendulum = false;
boolean paused = false;
boolean drawCopyright = false;

void setup() {
    size(700, 600);
    strokeWeight(2);
}

void drawPendulumPath(DoublePendulum dp) {
    // Draw a fading trail of lines
    int i = 0;
    for (Node n = dp.prevPositions.head.next; n != null; n = n.next) {
        float opacity = 255 / (dp.prevPositions.size - i);
        stroke(strokeColors[currentBackground], opacity);
        line(n.prev.data[0], n.prev.data[1], n.data[0], n.data[1]);
        i++;
    }
}

// Draw the double pendulum (lines and masses) at the xy position
void drawDoublePendulum(DoublePendulum dp, float angle1, float angle2, float opacity) {
    int originX = 400;
    int originY = 100;

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
    stroke(strokeColors[currentBackground], opacity);
    line(originX, originY, x1, y1);
    line(x1, y1, x2, y2);

    // Draw the masses with no outline
    noStroke();
    fill(fillColors[currentBackground], opacity);
    ellipse(x1, y1, dp.mass1, dp.mass1);
    ellipse(x2, y2, dp.mass2, dp.mass2);
}

void drawDoublePendulumMotion(DoublePendulum dp) {
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

void drawScrollingText() {
    textSize(15);
    int textX = 0;
    if (drawCopyright) {
        copyrightX -= copyrightDirection * 2;
        if (copyrightWidth != -1 && (copyrightX < -copyrightWidth / 2 || copyrightX > 400 + copyrightWidth / 2))
          copyrightDirection *= -1;
        for (int i = 0; i < copyright.length; i++) {
            text(copyright[i], copyrightX + textX, textY);
            textX += textWidth(copyright[i]) + 25;
        }
        copyrightWidth = textX;
    } else {
        objectX -= objectsDirection * 2;
        if (objectsWidth != -1 && (objectX < -objectsWidth / 2 || objectX > objectsWidth / 2))
          objectsDirection *= -1;
        for (int i = 0; i < objectNames.length; i++) {
            text(objectNames[i], objectX + textX, textY);
            textX += textWidth(objectNames[i]) + 25;
        }
        objectsWidth = textX;
    }
}

void mouseReleased() {
    // Cycle through the program state on right click
    if (mouseButton == RIGHT) {
        currentBackground = (currentBackground + 1) % 4;
        tracePendulumPath = currentBackground == 1 || currentBackground == 3;
        tracePendulum = currentBackground == 2 || currentBackground == 3;
        
        if (!tracePendulum) dp.prevAngles.empty();
        if (!tracePendulumPath) dp.prevPositions.empty();
    }
    
    // Toggle scrolling objects and copyright
    if (mouseButton == LEFT) {
        int padding = 30;
        if (mouseY > textY - padding / 2 && mouseY < textY + padding / 2)
            drawCopyright = !drawCopyright;
    }
}

void mouseDragged() {
    gravitySlider.handleDrag();
    rodSlider1.handleDrag();
    rodSlider2.handleDrag();
    massSlider1.handleDrag();
    massSlider2.handleDrag();
}

void keyReleased() {
    // Toggle pause
    if (key == ' ')
        paused = !paused;
}

void draw() {
    if (!paused) {
        // Gravity is inversely proportional. More gravity should make
        // the pendulum go slower.
        float realG = gravitySlider.rangeEnd - gravitySlider.value;
        realG /= gravitySlider.rangeEnd - gravitySlider.rangeStart;
        dp.gravity = realG;

        dp.rod1 = rodSlider1.value;
        dp.rod2 = rodSlider2.value;
        dp.mass1 = massSlider1.value;
        dp.mass2 = massSlider2.value;
        dp.step(tracePendulum);
    }

    background(bgColors[currentBackground]);
    drawDoublePendulumMotion(dp);
    gravitySlider.draw();
    rodSlider1.draw();
    rodSlider2.draw();
    massSlider1.draw();
    massSlider2.draw();
    drawScrollingText();
}
