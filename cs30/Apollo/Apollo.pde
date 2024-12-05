import java.lang.Math;

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

Complex sqrt(Complex a) {
  double real = Math.sqrt((a.abs() + a.real) / 2);
  double imag = (a.imag / Math.abs(a.imag)) * Math.sqrt((a.abs() - a.real) / 2);
  return new Complex(real, imag);
}

// Use Descartes theorem to find the curvature of
// the 4th circle from the curvatures of 3 other circles
double findCurvature(double k1, double k2, double k3) {
  double x = k1 + k2 + k3;
  double y = 2 * Math.sqrt(k1*k2 + k2*k3 + k3*k1);
  return x + y;
}

// Use the Complex Descartes theorem to find the radius of a 4th circle from
// the curvatures of 4 other circles and the positions of 3 other circles
Complex findCenter(Complex z1, Complex k1, Complex z2, Complex k2, Complex z3, Complex k3, Complex k4) {
  Complex a = add(add(mul(z1, k1), mul(z2, k2)), mul(z3, k3));
  Complex b = mul(mul(k1, k2), mul(z1, z2));
  Complex c = mul(mul(k2, k3), mul(z2, z3));
  Complex d = mul(mul(k1, k3), mul(z1, z3));
  Complex e = sqrt(add(add(b, c), d));
  Complex f = add(a, mul(new Complex(2), e));
  return div(f, k4);
}

class Circle {
  Complex center;
  Complex curvature;
  float radius;

  Circle(float x, float y, int radius) {
    this.center = new Complex(x, y);
    this.curvature = new Complex(1.0 / radius);
    this.radius = radius;
  }

  // Determine a circle from 3 other circles
  Circle(Circle a, Circle b, Circle c) {
    this.curvature = new Complex(findCurvature(a.curvature.real, b.curvature.real, c.curvature.real));
    this.radius = (float)(1.0 / this.curvature.real);
    this.center =
        findCenter(a.center, a.curvature, b.center, b.curvature, c.center, c.curvature, this.curvature);
  }

  void render() {
    circle((float)this.center.real, (float)this.center.imag, this.radius); 
  }
}

Circle circle1;
Circle circle2;
Circle circle3;
Circle circle4;

void setup() {
  size(600, 600);

  float x = width/2.5;
  float y = height/2.5;
  float r = 100;
  circle1 = new Circle(x, y, 100);
  circle2 = new Circle(x+r, y, 100);
  circle3 = new Circle(x+r/2, y+r-15, 100);
  circle4 = new Circle(circle1, circle2, circle3);
}

void draw() {
  background(255);
  circle1.render();
  circle2.render();
  circle3.render();
  circle4.render();
}
