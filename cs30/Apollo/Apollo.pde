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

// Use Descartes theorem to find the radius of
// a 4th circle from the curvatures of 3 other circles
double findRadius(double k1, double k2, double k3) {
  double x = k1 + k2 + k3;
  double y = 2 * Math.sqrt(k1*k2 + k2*k3 + k3*k1);
  double k4 = x + y;
  double radius = 1 / k4;
  return radius;
}

// Use the Complex Descartes theorem to find the radius of a 4th circle from
// the curvatures of 4 other circles and the positions of 3 other circles
Complex findCenter(Complex z1, double k1, Complex z2, double k2, Complex z3, double k3, double k4) {
  Complex x1 = new Complex(k1), x2 = new Complex(k2), x3 = new Complex(k3), x4 = new Complex(k4);

  Complex a = add(add(mul(z1, x1), mul(z2, x2)), mul(z3, x3));
  Complex b = mul(mul(x1, x2), mul(z1, z2));
  Complex c = mul(mul(x2, x3), mul(z2, z3));
  Complex d = mul(mul(x1, x3), mul(z1, z3));
  Complex e = sqrt(add(add(b, c), d));
  Complex f = add(a, mul(new Complex(2), e));

  return div(f, x4);
}

Complex circle1;
Complex circle2;
Complex circle3;
Complex circle4;
double k1, k2, k3, k4;

void setup() {
  size(600, 600);
  
  k1 = k2 = k3 = 100;
  circle1 = new Complex(width/4, height/4);
  circle2 = new Complex(width-width/4, height/4);
  circle3 = new Complex(width / 2, height - height / 4);

  double k4 = findRadius(k1, k2, k3);
  circle4 = findCenter(circle1, k1, circle2, k2, circle3, k3, k4);
  
  println(circle4.real, circle4.imag, k4);
}

void draw() {
  background(255);

  circle((float)circle1.real, (float)circle2.imag, (float)k1);
  circle((float)circle2.real, (float)circle2.imag, (float)k2);
  circle((float)circle3.real, (float)circle3.imag, (float)k3);
  circle((float)circle4.real, (float)circle4.imag, (float)k4);
}
