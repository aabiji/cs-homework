/*
TODO:
- Production rules, but applied in 3D
- Variability and randomness included in the branching
- Incorporation of light(s) into the scene
*/

import java.util.HashMap;

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
    this.radius = Math.abs(1/curvature);
  }

  String key() {
    return String.format("%f+%fi, %f, %f", center.real, center.imaginary, curvature, radius);
  }

  void draw() {
    stroke(0);
    noFill();
    circle(center.real, center.imaginary, radius * 2);
  }
}

// Use descartes theorem to get the 2 possible curvatures
// from the 3 other circle curvature
float[] getCurvatures(float k1, float k2, float k3) {
  float x = k1 + k2 + k3;
  float y = 2 * (float)Math.sqrt(k1*k2 + k2*k3 + k3*k1);
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

// Return true if the 2 circles are all tangent to each other
// There are 2 cases, 1 where the first circle is inside the second
// circle and one where the circles are right next to each other
boolean tangencial(Circle c1, Circle c2) {
  float epsilon = 0.1;
  float distance = dist(c1.center.real, c1.center.imaginary, c2.center.real, c2.center.imaginary);
  float r1 = c1.radius, r2 = c2.radius;
  return Math.abs(distance - (r1 + r2)) < epsilon || Math.abs(distance - Math.abs(r2 - r1)) < epsilon;
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

HashMap<String, Circle> circles;

// Recursively generate new circles from triplets of circles
void generateGasket(Circle c1, Circle c2, Circle c3, int depth) {
  if (depth <= 0) return;

  Circle[] newCircles = getNewCircles(c1, c2, c3);
  for (Circle c : newCircles) {
    if (c.radius < 3) continue; // Too small
    if (circles.get(c.key()) != null)
      continue; // Ignore duplicate circles
    if (!tangencial(c, c1) || !tangencial(c, c2) || !tangencial(c, c3))
      continue; // Descartes theorem only works with tangencial circles

    circles.put(c.key(), c);
    generateGasket(c1, c2, c, depth - 1);
    generateGasket(c2, c3, c, depth - 1);
    generateGasket(c1, c3, c, depth - 1);
  }
}

// Basic camera to rotate around the origin (0, 0, 0)
class Camera {
  float distance;
  PVector rotation;

  Camera() {
    distance = 500;
    rotation = new PVector(270, 0);
  }

  void updateRotation() {
    float sensitivity = 0.5;
    float deltaX = (mouseX - pmouseX) * sensitivity;
    float deltaY = (mouseY - pmouseY) * sensitivity;

    rotation.x = (rotation.x + deltaX) % 360;
    // Clamp the y rotation to prevent gimbal lock
    // We could just use a rotation matrix instead of
    // Euler's angles (roll, pitch, yaw), but meh
    rotation.y = constrain(rotation.y + deltaY, -89, 89);
  }

  void zoom(float direction) {
    distance = distance + direction * 20;
    distance = constrain(distance, 200, 1000);
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

void setup() {
  size(600, 600, P3D);
  /*
  Circle c1 = new Circle(new Complex(200, 200), -1.0/200);
  Circle c2 = new Circle(new Complex(100, 200), 1.0/100);
  Circle c3 = new Circle(new Complex(300, 200), 1.0/100);
  circles = new HashMap<String, Circle>();
  circles.put(c1.key(), c1);
  circles.put(c2.key(), c2);
  circles.put(c3.key(), c3);
  generateGasket(c1, c2, c3, 3);
  */
  camera = new Camera();
}

void mouseWheel(MouseEvent event) {
  camera.zoom(event.getCount());
}

void draw() {
  background(0);
  noStroke(); // remove wireframe
  lights();

  camera.updateRotation();
  camera.set();

  pushMatrix();
  translate(0, 0, 0);
  fill(255);
  box(100);
  popMatrix();
}
