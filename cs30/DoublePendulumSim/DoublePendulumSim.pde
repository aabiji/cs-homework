/*
Double Pendulum Simulator
Abigail Adegbiji - September 26, 2024

TODO: rewrite this -- refactor more
This programs simulates a double pendulum and allows the user
to control various aspects of it. The program has 4 possible states:
In the first state, we have a normal simulation, in the second state
our simulation will draw the path of the pendulum, in the third state,
our simulation will draw the path of the entire pendulum and in the last
state, our simulation will draw both the path of the pendulum and the path
of the entire pendulum.
*/

class Node {
  Float[] data;
  Node prev, next;

  Node() {
    data = new Float[2];
    prev = next = null;
  }
}

class List {
  Node head, tail;
  int length, maxLength;

   List(int max) {
    head = new Node();
    tail = head;
    length = 1;
    maxLength = max;
   }

  void insertAtEnd(float a, float b) {
    if (head == null) return;

    // Make sure we've filled our empty starting node first
    boolean headFilled = head.data[0] != null;
    if (!headFilled) {
      head.data[0] = a;
      head.data[1] = b;
      return;
    }

    Node node = new Node();
    node.data[0] = a;
    node.data[1] = b;
    length++;

    // Add a forwards pointer to our new node
    // and make our new node the tail
    tail.next = node;
    node.prev = tail;
    tail = node;
  }

   void add(float a, float b) {
    insertAtEnd(a, b);
    if (length >= maxLength)
        removeHead();
   }

   void removeHead() {
    if (head.next == null) return;
    // Move all the elements up by 1 place. This is fast because
    // instead of having to shift all elements up one by one, we
    // can just replace the head node and have Java clean it up for us.
    head.next.prev = null;
    head = head.next;
    length--;
   }

   void empty() {
    // "Remove" all elements from the list by replacing the head node with an empty one
    length = 1;
    head = new Node();
    tail = head;
   }
}

class Pendulum {
  float a_vel = 0.0;  // Angular velocity
  float a_acc = 0.0;  // Angular acceleration
  float angle = PI/4; // Angle of the rod from the origin
  float rod   = 0.0;  // Rod length
  float mass  = 0.0;  // Mass weight
}

// Handles simulating the behaviour of a double pendulum
class DoublePendulum {
  Pendulum top;
  Pendulum bottom;
  float gravity;
  List positions; // xy positions of the pendulum's path
  List angles;    // angles of the pendulum's rods

  DoublePendulum() {
    positions = new List(65);
    angles = new List(10);
    top = new Pendulum();
    bottom = new Pendulum();
  }

  Float[] getCoordinates(int originX, int originY, float angle1, float angle2) {
    // This looks backwards, but since the angle in our triangle
    // is shooting downwards, the x value would be the
    // opposite and the y value would be the adjacent
    Float[] values = new Float[4]; // {x1, y1, x2, y2}
    values[0] = originX - top.rod * sin(angle1);
    values[1] = originY + top.rod * cos(angle1);
    values[2] = values[0] - bottom.rod * sin(angle2);
    values[3] = values[1] + bottom.rod * cos(angle2);
    return values;
  }

  // Compound the angular accelerations to the angular velocities
  // and the angular velocities to the angles. The equations of motions come from
  // here: https://www.myphysicslab.com/pendulum/double-pendulum-en.html
  void substep(int substepCount) {
    // TODO: ask him about this
    float den = (2 * top.mass + bottom.mass - bottom.mass * cos(2 * top.angle - 2 * bottom.angle));
    float a = -gravity * (2 * top.mass + bottom.mass) * sin(top.angle);
    float b = -bottom.mass * gravity * sin(top.angle - 2 * bottom.angle);
    float c = -2 * sin(top.angle - bottom.angle) * bottom.mass;
    float d = bottom.a_vel * bottom.a_vel * bottom.rod;
    float e = top.a_vel * top.a_vel * top.rod * cos(top.angle - bottom.angle);
    float f = 2 * sin(top.angle - bottom.angle);
    float g = top.a_vel * top.a_vel * top.rod * (top.mass + bottom.mass);
    float h = gravity * (top.mass + bottom.mass) * cos(top.angle);
    float i = bottom.a_vel * bottom.a_vel * bottom.rod * bottom.mass * cos(top.angle - bottom.angle);

    top.a_acc = (a + b + c * (d + e)) / (top.rod * den);
    top.a_vel += top.a_acc / substepCount;
    top.angle += top.a_vel / substepCount;
    top.angle %= 2 * PI; // Force angle to be between -PI and PI

    bottom.a_acc = f * (g + h + i) / (bottom.rod * den);
    bottom.a_vel += bottom.a_acc / substepCount;
    bottom.angle += bottom.a_vel / substepCount;
    bottom.angle %= 2 * PI; // Force angle to be between -PI and PI
  }

  void step(boolean recordPath, boolean recordAngles, int count, int x, int y) {
    // Since we are using numerical methods, our simulation will be prone to errors.
    // There are analytical solutions to the double pendulum problem, but as of now,
    // they are still approximate. So, we'll stick with our numerical solution,
    // but split the simulation into substeps to try to minimize error. This explanation is nice:
    // https://stackoverflow.com/questions/67203975/why-is-my-code-for-a-double-pendulum-returning-nan
    for (int i = 0; i < count; i++) {
      substep(count);
    }

    Float[] xy = getCoordinates(x, y, top.angle, bottom.angle);
    if (recordPath)
      positions.add(xy[2], xy[3] + bottom.mass / 2);

    if (recordAngles)
      angles.add(top.angle, bottom.angle);
  }
}

// Slider UI component
class Slider {
  String name;
  int x, y, lineWidth , value;
  int rangeStart, rangeEnd;

  Slider(String id, int initial, int xpos, int ypos, int start, int end, int dragWidth) {
    x = xpos;
    y = ypos;
    lineWidth = dragWidth;
    rangeStart = start;
    rangeEnd = end;
    value = initial;
    name = id;
  }

  void draw() {
    int textHeight = 20;
    stroke(strokeColors[currentBackground]);
    fill(fillColors[currentBackground]);
    textSize(textHeight);
    strokeWeight(4);

    // Draw the labels and the slider line
    String str = String.format("%d", value);
    text(str, x - textWidth(str) * 1.5, y + textHeight / 3);
    text(name, x + lineWidth - textWidth(name), y - textHeight);
    line(x, y, x + lineWidth, y);

    // Draw the slider drag handle
    noStroke();
    float handleX = map(value, rangeStart, rangeEnd, 0, lineWidth);
    ellipse(x + handleX, y, 10, 10);
    strokeWeight(2);
  }

  void handleDrag() {
    int padding = 30;
    boolean onSlider = mouseY > y - padding / 2 && mouseY < y + padding / 2;
    if (!onSlider) return; // Only drag when our cursor is on the slider
    int xpos = max(x, min(mouseX, x + lineWidth)); // Clamp to the slider bounds
    value = (int)map(xpos - x, 0, lineWidth, rangeStart, rangeEnd);
  }
}

Slider sliders[];
color bgColors[] = {color(255, 255, 255), color(255, 255, 255), color(0, 0, 0), color(19, 41, 61)};
color fillColors[] = {color(34, 34, 34),  color(255, 104, 107), color(255, 0, 0), color(27, 152, 224)};
color strokeColors[] = {color(75, 78, 109), color(49, 175, 144),  color(0, 255, 0), color(0, 100, 148)};
String copyright[] = {"© Abigail Adegbiji", "September 26, 2024"};
String objects[] = {"Gravity slider", "Rod #1", "Rod #1 slider", "Rod #2", "Rod #2 slider", "Mass #1", "Mass #1 slider", "Mass #2", "Mass #2 slider"};

int currentBackground = 0;
boolean paused = false;
boolean drawCopyright = false;
boolean drawMany = false;
boolean drawPath = false;
DoublePendulum dp = new DoublePendulum();

int originX = 450;
int originY = 100;
int textY = 550;
int scrollX = 400;

void setup() {
  size(700, 600);
  strokeWeight(2);

  // Create our set of sliders
  int index = 0;
  sliders = new Slider[5];
  for (int i = 0; i < objects.length; i++) {
    String objectName = objects[i];
    if (objectName.contains("slider")) {
      String name = objectName.replace(" slider", "");
      int value = name.contains("Gravity") ? 1 : name.contains("Mass") ? 20 : 100;
      int start = name.contains("Gravity") ? 1 : name.contains("Mass") ? 10 : 100;
      int end = name.contains("Gravity") ? 10 : name.contains("Mass") ? 50 : 250;
      sliders[index++] = new Slider(name, value, 100, 100 + i * 40, start, end, 100);
    }
  }
}

void drawPendulumPath() {
  // Draw a fading trail of lines following the pendulum's path
  int i = 0;
  for (Node n = dp.positions.head.next; n != null; n = n.next) {
    float opacity = 255 / (dp.positions.length - i);
    stroke(strokeColors[currentBackground], opacity);
    line(n.prev.data[0], n.prev.data[1], n.data[0], n.data[1]);
    i++;
  }
}

void drawDoublePendulum(float angle1, float angle2, float opacity) {
  Float[] coordinates = dp.getCoordinates(originX, originY, angle1, angle2);

  // Draw the pendulum rods
  stroke(strokeColors[currentBackground], opacity);
  line(originX, originY, coordinates[0], coordinates[1]);
  line(coordinates[0], coordinates[1], coordinates[2], coordinates[3]);

  // Draw the pendulum masses with no outline
  noStroke();
  fill(fillColors[currentBackground], opacity);
  ellipse(coordinates[0], coordinates[1], dp.top.mass, dp.top.mass);
  ellipse(coordinates[2], coordinates[3], dp.bottom.mass, dp.bottom.mass);
}

void drawDoublePendulumMotion() {
  if (drawPath) drawPendulumPath();
  if (!drawMany) {
    drawDoublePendulum(dp.top.angle, dp.bottom.angle, 255);
    return;
  }

  // Draw a fading trail of double pendulums
  int i = 0;
  for (Node n = dp.angles.head; n != null; n = n.next) {
    float opacity = 255 / (dp.angles.length - i);
    drawDoublePendulum(n.data[0], n.data[1], opacity);
    i++;
  }
}

void drawScrollingText() {
  textSize(15);
  int textX = 0;
  int scrollWidth = 0;
  String[] arr = drawCopyright ? copyright : objects;

  if (!paused) scrollX -= 2;
  for (int i = 0; i < arr.length; i++) {
    text(arr[i], scrollX + textX, textY);
    textX += textWidth(arr[i]) + 25;
  }

  if (scrollX < -textX)
    scrollX = 700; // Wrap back around
}

void mouseReleased() {
  // Cycle through the program state on right click
  if (mouseButton == RIGHT) {
    currentBackground = (currentBackground + 1) % 4;
    drawPath = currentBackground == 1 || currentBackground == 3;
    drawMany = currentBackground == 2 || currentBackground == 3;
    if (!drawMany) dp.angles.empty();
    if (!drawPath) dp.positions.empty();
  }

  // Toggle between scrolling objects and copyright
  if (mouseButton == LEFT) {
    int padding = 30;
    boolean onText = mouseY > textY - padding / 2 && mouseY < textY + padding / 2;
    if (onText) drawCopyright = !drawCopyright;
  }
}

void mouseDragged() {
  for (int i = 0; i < 5; i++) {
    sliders[i].handleDrag();
  }
}

void keyReleased() {
  // Toggle pause
  if (key == ' ') paused = !paused;
}

void draw() {
  // Gravity is inversely proportional.
  float realG = sliders[0].rangeEnd - sliders[0].value;
  realG /= sliders[0].rangeEnd - sliders[0].rangeStart;
  dp.gravity = realG;

  // Se the pendulum values
  dp.top.rod = sliders[1].value;
  dp.bottom.rod = sliders[2].value;
  dp.top.mass = sliders[3].value;
  dp.bottom.mass = sliders[4].value;

  if (!paused)
    dp.step(drawPath, drawMany, 50, originX, originY);

  background(bgColors[currentBackground]);
  drawDoublePendulumMotion();
  text("Press SPACE to toggle pause", 50, 480);
  for (int i = 0; i < 5; i++) {
    sliders[i].draw();
  }
  drawScrollingText();
}
