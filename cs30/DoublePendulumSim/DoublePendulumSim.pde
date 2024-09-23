// TODO: our liberal use of global variables is questionable
//       is there any way to improve performance?
//       is there a better alternative to arr.remove(0);

import java.util.ArrayList;

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

    ArrayList<Float[]> prevPositions;
    ArrayList<Float[]> prevAngles;

    public DoublePendulum()
    {
        prevPositions = new ArrayList<Float[]>();
        prevAngles = new ArrayList<Float[]>();
    }

    void tracePath(float x, float y) {
        if (!tracePendulumPath) return;
        Float[] xy = {x, y};
        prevPositions.add(xy);
        if (prevPositions.size() >= 50) {
            prevPositions.remove(0);
        }
    }

    void traceAngles() {
        if (!tracePendulum) return;
        Float[] angles = {angle1, angle2};
        prevAngles.add(angles);
        if (prevAngles.size() >= 10) {
            prevAngles.remove(0);
        }
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

    void step(boolean tracePendulumPath, int x, int y)
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
        traceAngles();
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
    for (int i = 1; i < dp.prevPositions.size(); i++) {
        Float[] previous = dp.prevPositions.get(i - 1);
        Float[] current = dp.prevPositions.get(i);
        float opacity = 255 / (dp.prevPositions.size() - i);
        stroke(rodColors[currentBackground], opacity);
        line(previous[0], previous[1], current[0], current[1]);
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
    dp.tracePath(x2, y2 + dp.mass2 / 2);

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
    for (int i = 0; i < dp.prevAngles.size(); i++) {
        Float[] angles = dp.prevAngles.get(i);
        float opacity = 255 / (dp.prevAngles.size() - i);
        drawDoublePendulum(dp, angles[0], angles[1], opacity);
    }
}

void mouseReleased()
{
    // Cycle through the program state on right click
    if (mouseButton == RIGHT) {
        currentBackground = (currentBackground + 1) % 4;
        if (currentBackground != 1) dp.prevPositions.clear();
        tracePendulumPath = currentBackground == 1;
        tracePendulum = currentBackground == 2;
    }
}

void draw()
{
    background(bgColors[currentBackground]);
    dp.step(tracePendulumPath, originX, originY);
    drawDoublePendulumMotion(dp, originX, originY);
}
