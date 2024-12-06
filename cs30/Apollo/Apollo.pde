import java.lang.Math;
import java.util.ArrayList;

// A complex number is of the form a + bi, where a is the real part,
// We can use a single complex number to represent a (x, y) coordinate
class Complex {
  double real; // real part
  double imag; // imaginary part

  Complex(double a, double b) {
     this.real = a;
     this.imag = b;
  }

  // A real number is a complex number where the imaginary part is 0
  Complex(double a) {
    this.real = a;
    this.imag = 0;
  }

  Complex reciprocal() {
    double scale = real * real + imag * imag;
    return new Complex(real / scale, -imag / scale);
  }

  double abs() {
    return Math.hypot(real, imag);
  }
}

Complex add(Complex a, Complex b) {
  double real = a.real + b.real;
  double imag = a.imag + b.imag;
  return new Complex(real, imag);
}

Complex mul(Complex a, Complex b) {
  double real = a.real * b.real - a.imag * b.imag;
  double imag = a.real * b.imag + a.imag * b.real;
  return new Complex(real, imag);
}

Complex div(Complex a, Complex b) {
  return mul(a, b.reciprocal());
}

// Since sqrt gives us +/-, sign is used to
// choose one of the 2 possible answers
Complex sqrt(Complex a, int sign) {
  // Find the sqrt by using the polar form of the complex number
  double theta = Math.atan2(a.imag, a.real);
  double sqrt = Math.sqrt(a.abs()); // sqrt of modulus

  double real = sqrt * Math.cos(theta / 2);
  double imag = sqrt * Math.sin(theta / 2);
  return new Complex(real * sign, imag * sign);
}

// Use Descartes theorem to find the curvature of
// the 4th circle from the curvatures of 3 other circles
// Since the equation is quadratic, sign is used to
// choose one of the 2 possible answers
double findCurvature(double k1, double k2, double k3, int sign) {
  double x = k1 + k2 + k3;
  double y = sign * 2 * Math.sqrt(k1*k2 + k2*k3 + k3*k1);
  return x + y;
}

// Use the Complex Descartes theorem to find the
// radius of a 4th circle from. The curvatures of 4
// circles (k) and the positions of 3 circles (z)
// Since the equation is quadratic, sign is used to
// choose one of the 2 possible answers
Complex findCenter(
  Complex z1, Complex k1,
  Complex z2, Complex k2,
  Complex z3, Complex k3,
  Complex k4, int sign
) {
  Complex a = add(add(mul(z1, k1), mul(z2, k2)), mul(z3, k3));
  Complex b = mul(mul(k1, k2), mul(z1, z2));
  Complex c = mul(mul(k2, k3), mul(z2, z3));
  Complex d = mul(mul(k1, k3), mul(z1, z3));
  Complex e = sqrt(add(add(b, c), d), sign);
  Complex f = add(a, mul(new Complex(2), e));
  return div(f, k4);
}

class Circle {
  Complex center;
  double curvature;
  float radius;

  Circle(double x, double y, int radius) {
    this.center = new Complex(x, y);
    this.curvature = 1.0 / radius;
    this.radius = radius;
  }

  // Determine a circle from 3 other circles
  // sign determines whether the new circle is inside (+1) or surrounding (-1) the 3 circles
  Circle(Circle a, Circle b, Circle c, int sign) {
    this.curvature = findCurvature(a.curvature, b.curvature, c.curvature, sign);
    this.radius = (float)(1.0 / this.curvature);
    this.center = findCenter(
      a.center, new Complex(a.curvature),
      b.center, new Complex(b.curvature),
      c.center, new Complex(c.curvature),
      new Complex(this.curvature), sign
    );
  }
}

ArrayList<Circle> circles;

void step() {
  int len = circles.size();
  for (int i = 0; i < len; i++) {
    for (int j = i + 1; j < len; j++) {
      for (int l = j + 1; l < len; l++) {
        circles.add(new Circle(circles.get(i), circles.get(j), circles.get(l), 1));
        circles.add(new Circle(circles.get(i), circles.get(j), circles.get(l),-1));
      }
    }
  }
}

void setup() {
  size(600, 600);

  // Add the initial circles
  int r = 100;
  double cx = width / 2;
  double cy = height / 2;
  circles = new ArrayList<Circle>();
  circles.add(new Circle(cx-r, cy, r));
  circles.add(new Circle(cx+r, cy, r));
  // The 3rd circle should be at the apex of equilateral
  // triangle formed by the first 2 circles. The height
  // of the equalateral triangle is radius * sqrt(3)
  circles.add(new Circle(cx, cy + r * Math.sqrt(3), r));

  step();
  step();
}

void draw() {
  background(255);
  fill(0, 0, 0, 0);
  for (Circle c : circles) {
    circle((float)c.center.real, (float)c.center.imag, c.radius * 2);
  }
}
