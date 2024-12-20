
public class StellarSeaLion extends Pinniped {
  StellarSeaLion(float size) {
    super(size);
    xSpeed = 3;
    ySpeed = 3;
    y = preferedDepth = 475;
    oxygenLevel = oxygenCapacity = 1.6;
  }

  void display(AnimatedObject objs[]) {
    super.react(objs);
    super.updateFlip();
    if(flip)firstPose(int(size * xDirection), x, y);
    else secondPose(int(size * xDirection), x, y);
  }

  void firstPose(int a, float x, float y)
  {
    pushMatrix();
    translate(x, y);
    scale(a, abs(a));
    fill(129, 111, 46);
    noStroke();

    float[] vertices = {
      0, 0, -0.2, -0.2, -0.4, -0.2, -0.5, -0.7, -1, -1,
      -1.6, -1, -2, -0.5, -2.8, -0.6, -3.6, -0.4, -4, -2.7,
      -5, -1.3, -4.4, 0, -5, 0.5, -5.7, 1.3, -6.4, 2.5,
      -6.5, 3, -8, 3.7, -7.3, 4.4, -6.2, 3.4, -6.4, 4.8,
      -5.3, 4.8, -5.8, 3.3, -5, 3, -3.7, 2.1, -3.8, 3.5,
      -2, 4.5, -2.8, 1.8, -1.6, 1.2, -1.3, 0.6, -0.8, 0.7,
      -0.2, 0.3, 0, 0
    };
    super.drawShape(vertices);

    strokeWeight(abs(a)/20 * 0.03);
    stroke(255);
    line(-0.3, 0.2, -0.5, 0.4);
    line(-0.2, 0.2, -0.4, 0.5);
    line(-0.1, 0.2, -0.3, 0.6);

    noStroke();
    fill(0);
    ellipse(-1, -0.5, 0.3, 0.3); //eye
    ellipse(-0.2, 0, 0.4, 0.3); //nose

    popMatrix();
  }

  void secondPose(int a, float x, float y)
  {
    pushMatrix();
    translate(x, y);
    scale(a, abs(a));
    noStroke();
    fill(129, 111, 46);

    float[] vertices = {
      0, 0, -0.2, -0.1, -0.5, 0.2, -1, 0, -1.5, 0,
      -2, 0.4, -3, 0.5, -3.5, -2, -4.8, -1, -4, 0.5,
      -5, 0.5, -6, 0.2, -6.5, 0, -6, -2, -7, -1.7,
      -7, 0, -8, -1.2, -8.5, -0.3, -7, 0.3, -6.8, 1.2,
      -6.4, 2, -5.3, 2.7, -4, 3, -4.5, 4, -3.5, 5.2,
      -3, 3, -2, 2.8, -0.8, 1.4, -0.2, 0.8, 0.1, 0.2, 0, 0
    };
    super.drawShape(vertices);

    strokeWeight(abs(a)/20 * 0.03);
    stroke(255);
    line(-0.3, 0.2, -0.5, 0.4);
    line(-0.2, 0.2, -0.4, 0.5);
    line(-0.1, 0.2, -0.3, 0.6);

    noStroke();
    fill(0);
    ellipse(-1.2, 0.2, 0.3, 0.3); //eye
    ellipse(-0.15, 0.1, 0.4, 0.3); //nose

    popMatrix();
  }

}
