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
  
  String fmt() {
    return String.format("(%f, %f)", real, imag);
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

Complex scale(Complex a, double b) {
  return new Complex(a.real * b, a.imag * b);
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
  Complex z1, double k1,
  Complex z2, double k2,
  Complex z3, double k3,
  double k4, int sign
) {
  Complex a = add(add(scale(z1, k1), scale(z2, k2)), scale(z3, k3));
  Complex b = scale(mul(z1, z2), k1 * k2);
  Complex c = scale(mul(z2, z3), k2 * k3);
  Complex d = scale(mul(z1, z3), k1 * k3);
  Complex e = sqrt(add(add(b, c), d), sign);
  Complex f = add(a, mul(new Complex(2), e));
  return scale(f, 1/k4);
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
      a.center, a.curvature,
      b.center, b.curvature,
      c.center, c.curvature,
      this.curvature, sign
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

/*
https://www.mitchr.me/SS/AGasket/index.html

require 'cmath'

def newCircles (circle1, circle2, circle3)
  k1, k2, k3 = circle1[0], circle2[0], circle3[0]
  c1, c2, c3 = circle1[1], circle2[1], circle3[1]
  # Compute the inner and outer circle radius
  tmp1 = k1+k2+k3
  tmp2 = 2*Math::sqrt(k1*k2+k2*k3+k3*k1)
  iRad = tmp1+tmp2
  oRad = tmp1-tmp2
  if(iRad < oRad) then
    iRad, oRad = oRad, iRad
  end
  # Compute the coordinates
  tmp1 = c1*k1+c2*k2+c3*k3
  tmp2 = 2*CMath::sqrt(k1*k2*c1*c2+k2*k3*c2*c3+k3*k1*c1*c3)

  circles = [ [iRad, (tmp1+tmp2)/iRad ],
              [oRad, (tmp1-tmp2)/oRad ]
            ]
  return circles  
end

r1 = 1.0
r2 = 1.0
r3 = 1.0
tmp = (r1*r1+r1*r3+r1*r2-r2*r3)/(r1+r2)
circle1 = [ 1/r1, Complex(    0,                             0) ]
circle2 = [ 1/r2, Complex(r1+r2,                             0) ]
circle3 = [ 1/r3, Complex(  tmp, Math::sqrt((r1+r3)**2-tmp**2)) ]
print(newCircles(circle1, circle2, circle3))

Output:
[
  [6.464101615137754, (1.0+0.5773502691896257i)], # inner circle (curvature, center)
  [-0.4641016151377544, (1.0+0.5773502691896262i)] # outer circle (curvature, center)
]
*/

void setup() {
  size(600, 600);

  // Add the initial circles
  int r = 1;
  circles = new ArrayList<Circle>();
  circles.add(new Circle(0, 0, r));
  circles.add(new Circle(r+r, 0, r));
  // The 3rd circle should be at the apex of equilateral
  // triangle formed by the first 2 circles. The height
  // of the equalateral triangle is radius * sqrt(3)
  double h = (r * 2 * Math.sqrt(3)) / 2;
  circles.add(new Circle(r, h, r));

  step();

  Circle inner = circles.get(3);
  Circle outer = circles.get(4);
  println(inner.curvature, inner.center.fmt());
  println(outer.curvature, outer.center.fmt());
}

void draw() {
  background(255);
  ellipseMode(RADIUS);
  fill(0, 0, 0, 0);
  for (Circle c : circles) {
    float r = Math.abs(c.radius) * 100;
    float x = (float)c.center.real + width/2;
    float y = (float)c.center.imag + height/2;
    ellipse(x, y, r, r);
  }
}
