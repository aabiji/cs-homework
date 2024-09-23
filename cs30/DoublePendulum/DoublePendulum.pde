import java.util.ArrayList;

float gravity = 1; // gravitational constatnt

float angular_vel1 = 0; // First angular velocity
float angular_acc1 = 0; // First angular acceleration
float angle1 = PI/4; // angle 1
float rod1 = 100; // length of first rod
float mass1 = 20; // size of the first mass
float x1 = 0;
float y1 = 0;

float angular_vel2 = 0;
float angular_acc2 = 0;
float angle2 = PI/8;
float rod2 = 100;
float mass2 = 20;
float x2 = 0;
float y2 = 0;

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

int state = 0; // ranges from 0 to 
boolean tracePendulumPath = false;
boolean tracePendulum = false;
ArrayList<Float[]> path;
int pathSize = 32;

void setup()
{
  size(600, 600);
  strokeWeight(2);
  path = new ArrayList<Float[]>();
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

void stepSimulation()
{
  // Since we are using numerical methods, our simulation will be
  // prone to errors. There are analytical solutions to the double
  // pendulum problem, but as of now, even they are approximate.
  // So, we'll stick with our numerical solution, but split the
  // simulation into substeps to try to minimize error So, we'll
  // basically do 100 mini steps per frame.
  // This [explanation](https://stackoverflow.com/questions/67203975/why-is-my-code-for-a-double-pendulum-returning-nan)
  // is really nice
  int substepCount = 1000;
  for (int i = 0; i < substepCount; i++) {
    subStep(substepCount);
  }

  // Record the path of the pendulum
  if (tracePendulumPath) {
    // Since we're appending, the most recent positions should be at the end
    Float[] xy = {x2, y2 + mass2 / 2};
    path.add(xy);
    if (path.size() >= pathSize) {
      // Shift all elements up. TODO: is there a faster way?
      path.remove(0);
    }
  }
}

// Draw the double pendulum (lines and masses) at the xy position
void drawDoublePendulum(int x, int y)
{
  // This looks backwards, but since the angle in our triangle
  // is shooting downwards, the x value would be the
  // opposite and the y value would be the adjacent
  x1 = x - rod1 * sin(angle1);
  y1 = y + rod1 * cos(angle1);

  x2 = x1 - rod2 * sin(angle2);
  y2 = y1 + rod2 * cos(angle2);

  // Draw the rods
  stroke(rodColors[state]);
  line(x, y, x1, y1);
  line(x1, y1, x2, y2);

  // Draw the masses with no outline
  noStroke();
  fill(fillColors[state]);
  ellipse(x1, y1, mass1, mass1);
  ellipse(x2, y2, mass2, mass2);
}

void drawPendulumPath() {
  strokeWeight(5);
  for (int i = 1; i < path.size(); i++) {
    Float[] previous = path.get(i - 1);
    Float[] current = path.get(i);
    float opacity = 255 / (path.size() - i);
    stroke(rodColors[state], opacity);
    line(previous[0], previous[1], current[0], current[1]);
  }
  strokeWeight(2);
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    // Cycle through the state
    state = (state + 1) % 4;
    tracePendulumPath = state == 1;
    tracePendulum = state == 2;
  }
}

void draw()
{
  background(bgColors[state]);
  stepSimulation();
  drawDoublePendulum(300, 100);
  if (tracePendulumPath) drawPendulumPath();
}
