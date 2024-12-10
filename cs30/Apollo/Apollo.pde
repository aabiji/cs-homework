/*
Apollo
------
Abigail Adegbiji
December 10, 2024

A program to visualize an Apollonian gasket in 3d.

TODO: fix lightling ask question about extending to 3d and done!

Ressources:
- https://www.youtube.com/watch?v=6UlGLB_jiCs
- https://en.wikipedia.org/wiki/Descartes%27_theorem
- https://www.wikihow.com/Create-an-Apollonian-Gasket

Production rules:
1. Start with three circles that are tangent to each other
2. Calculate the radii and positions of new circles that are tangent to all three
3. Form new sets of 3 circles using the existing circles and the new circles
4. Recursively repeat the process
*/

import java.util.ArrayList;

class Complex {
  float real;
  float imaginary;

  Complex(float real, float imaginary) {
    this.real = real;
    this.imaginary = imaginary;
  }

  Complex add(Complex b) {
    return new Complex(this.real + b.real, this.imaginary + b.imaginary);
  }

  Complex sub(Complex b) {
    return new Complex(this.real - b.real, this.imaginary - b.imaginary);
  }

  Complex mul(Complex b) {
    float x = real * b.real - imaginary * b.imaginary;
    float y = real * b.imaginary + b.real * imaginary;
    return new Complex(x, y);
  }

  Complex scale(float b) {
    return new Complex(this.real * b, this.imaginary * b);
  }

  Complex sqrt() {
    // convert eh complex number to polar form
    double magnitude = Math.sqrt(Math.sqrt(real * real + imaginary * imaginary));
    double angle = Math.atan2(imaginary, real) / 2;
    // convert it back to non polar form
    double x = magnitude * Math.cos(angle);
    double y = magnitude * Math.sin(angle);
    return new Complex((float)x, (float)y);
  }
}

class Circle {
  Complex center;
  float curvature, radius;

  Circle(Complex xy, float curvature) {
    this.center = xy;
    this.curvature = curvature;
    this.radius = abs(1/curvature);
  }
}

// Use descartes theorem to get the 2 possible curvatures
// from the 3 other circle curvature
float[] getCurvatures(float k1, float k2, float k3) {
  float x = k1 + k2 + k3;
  float discriminant = abs(k1*k2 + k2*k3 + k3*k1);
  float y = 2 * (float)Math.sqrt(discriminant);
  float[] solution = {x + y, x - y};
  return solution;
}

// Use the complex descartes theorem to find the center point
// of the 2 possible circles from 3 other circles
Complex[] getCenters(Circle c1, Circle c2, Circle c3, float k4) {
  Complex zk1 = c1.center.scale(c1.curvature);
  Complex zk2 = c2.center.scale(c2.curvature);
  Complex zk3 = c3.center.scale(c3.curvature);
  Complex x = zk1.add(zk2).add(zk3);
  Complex y = zk1.mul(zk2).add(zk2.mul(zk3)).add(zk1.mul(zk3));
  Complex z = y.sqrt().scale(2);
  Complex[] solution = { x.add(z).scale(1 / k4), x.sub(z).scale(1 / k4) };
  return solution;
}

// Get all of the 4 possible new circles from 3 circles
Circle[] getNewCircles(Circle c1, Circle c2, Circle c3) {
  int index = 0;
  Circle[] circles = new Circle[4];

  float[] curvatures = getCurvatures(c1.curvature, c2.curvature, c3.curvature);
  for (float curvature : curvatures) {
    Complex[] centers = getCenters(c1, c2, c3, curvature);
    circles[index++] = new Circle(centers[0], curvature);
    circles[index++] = new Circle(centers[1], curvature);
  }

  return circles;
}

// Return true if the 2 circles are all tangent to each other
// There are 2 cases, 1 where the first circle is inside the second
// circle and one where the circles are right next to each other
boolean tangencial(Circle c1, Circle c2) {
  float epsilon = 0.1;
  float distance = dist(c1.center.real, c1.center.imaginary, c2.center.real, c2.center.imaginary);
  float r1 = c1.radius, r2 = c2.radius;
  boolean case1 = abs(distance - (r1 + r2)) < epsilon; // where c1 and c2 are adjacent
  boolean case2 = abs(distance - abs(r2 - r1)) < epsilon; // where c2 is inside c1
  return case1 || case2;
}

boolean alreadyGenerated(ArrayList<Circle> circles, Circle c) {
  for (Circle other : circles) {
    float distance = dist(c.center.real, c.center.imaginary, other.center.real, other.center.imaginary);
    if (distance < 0.1) return true; // Both circles have the same position
  }
  return false;
}

// Recursively generate new circles from triplets of circles
void generateGasket(ArrayList<Circle> circles, Circle c1, Circle c2, Circle c3, int depth) {
  if (depth <= 0) return;

  Circle[] newCircles = getNewCircles(c1, c2, c3);
  for (Circle c : newCircles) {
    if (c.radius < 3 || alreadyGenerated(circles, c)) continue;
    if (!tangencial(c, c1) || !tangencial(c, c2) || !tangencial(c, c3))
      continue; // Descartes theorem only works with tangencial circles

    circles.add(c);
    generateGasket(circles, c1, c2, c, depth - 1);
    generateGasket(circles, c2, c3, c, depth - 1);
    generateGasket(circles, c1, c3, c, depth - 1);
  }
}

// Get a random configuration of 3 mutally tangent circles
// This will produce a unique fractal pattern
Circle[] getInitialCircles() {
  Circle[] circles = new Circle[3];

  // Random circle radii
  float r1 = random(100, 400);
  float r2 = random(20, r1 / 2);
  float r3 = r1 - r2;

  // Random unit vector
  PVector vector = new PVector(random(0, 1), random(0, 1));

  // Outer circle
  circles[0] = new Circle(new Complex(0, 0), -1.0 / r1);

  // Position the first inner circle at a random position inside the circle
  vector.setMag(r1 - r2);
  circles[1] = new Circle(new Complex(vector.x, vector.y), 1.0 / r2);

  // Position the second inner circle by mirroring the first
  vector.rotate(PI);
  vector.setMag(r1 - r3);
  circles[2] = new Circle(new Complex(vector.x, vector.y), 1.0 / r3);

  return circles;
}

// Basic camera to rotate around the origin (0, 0, 0)
class Camera {
  float distance;
  PVector rotation;

  Camera() {
    distance = 600;
    rotation = new PVector(270, 0);
  }

  void updateRotation() {
    float sensitivity = 0.5;
    float deltaX = (mouseX - pmouseX) * sensitivity;
    float deltaY = (mouseY - pmouseY) * sensitivity;

    rotation.x = (rotation.x + deltaX) % 360;
    // Clamp the y rotation to prevent gimbal lock
    rotation.y = constrain(rotation.y + deltaY, -89, 89);
  }

  void zoom(float direction) {
    distance = distance + direction * 20;
    distance = constrain(distance, 200, 1200);
  }

  void set() {
    // Calculate the camera position. You could visualize this as
    // rotating around a circle on the xy plane with the z axis looking downwards
    float x = distance * cos(radians(rotation.x)) * cos(radians(rotation.y));
    float y = distance * sin(radians(rotation.y));
    float z = distance * sin(radians(rotation.x)) * cos(radians(rotation.y));
    camera(x, y, z, 0, 0, 0, 0, 1, 0);
  }
}

Camera camera;
ArrayList<Circle> circles;
color[] colors;

void setup() {
  size(600, 600, P3D);

  camera = new Camera();

  circles = new ArrayList<Circle>();
  Circle[] set = getInitialCircles();
  java.util.Collections.addAll(circles, set);
  generateGasket(circles, set[0], set[1], set[2], 10);

  // Assign each circle it's own color
  color[] palette = {
    color(252, 239, 239), color(127, 216, 190),
    color(161, 252, 223),color(252, 210, 159)
  };
  colors = new color[circles.size()];
  for (int i = 0; i < circles.size(); i++) {
    colors[i] = palette[(int)random(0, 4)];
  }
}

void mouseWheel(MouseEvent event) {
  camera.zoom(event.getCount());
}

void setLights() {
  ambientLight(128, 128, 128);
  lightFalloff(1, 0, 0);
  lightSpecular(0, 0, 0);
  shininess(10.0);

  // Put directional light in front and behind
  directionalLight(200, 200, 200, 0, 0, -100);
  directionalLight(200, 200, 200, 0, 0, 100);

  // Put point light in front and on top
  pointLight(200, 200, 200, 0, 1, -100);
  pointLight(200, 200, 200, 0, 0, -100);
}

void draw() {
  background(0);
  noStroke();

  setLights();
  camera.updateRotation();
  camera.set();

  // Draw the gasket (ignoring the outer "container" circle)
  for (int i = 1; i < circles.size(); i++) {
    Circle circle = circles.get(i);
    pushMatrix();
    translate(circle.center.real, circle.center.imaginary, 0);
    fill(colors[i]);
    sphere(circle.radius);
    popMatrix();
  }
}
