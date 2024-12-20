
public class BeardedSeal extends Pinniped {
  BeardedSeal(float size) {
    super(size);
    xSpeed = 2;
    ySpeed = 2;
    y = preferedDepth = 400;
  }

  void display(AnimatedObject objs[]) {
    super.react(objs);
    super.updateFlip();
    if(flip)firstPose(int(size * xDirection), x, y);
    else secondPose(int(size * xDirection), x, y);
  }

  void firstPose(int a, float x, float y)
  {
    noStroke();
    pushMatrix();
    translate(x, y);
    scale(a, abs(a));
    fill(150);

    // Draw body
    float[] vertices = {
      0, 0, -0.2, -0.8, -1, -1, -2, -0.9,
      -4, -1, -5.3, -0.8, -6, -0.6, -7, 0,
      -8, 1, -8.5, 0.7, -9, 0, -8.4, 0.2,
      -8, 1, -8.5, 1.2, -9, 2, -8.2, 1.4,
      -8, 1, -7, 1.4, -5, 1.7, -4, 1.7,
      -3.4, 1.6, -2, 1, -1.3, 0.8, -0.8, 0.8,
      -0.3, 0.5, 0,0
    };
    super.drawShape(vertices);

    fill(0);
    ellipse(-0.8, -0.5, 0.3, 0.3); //eye
    fill(255);
    ellipse(0, -0.2, 0.25, 0.25); //nose

    stroke(255); //change to white
    strokeWeight(abs(a)/20 * 0.1);
    line(0, -0.2, 0.4, 0.6);
    line(0, -0.2, 0.3, 0.9);
    line(0, -0.2, -0.2, 1);
    line(0, -0.2, -0.4, 0.9);

    popMatrix();
  }

  void secondPose(int a, float x, float y)
  {
    noStroke();
    pushMatrix();
    translate(x, y);
    scale(a, abs(a));
    fill(150);

    float[] vertices = {
      0, 0, -0.3, -0.7, -1, -0.9, -1.4, -0.8, -2, -0.4,
      -3, -0.8, -4, -1, -5, -1, -6, -0.6, -7.3, -0.5,
      -7.5, -1.5, -8, -2, -8, -1.5, -7.3, -0.5, -8, -0.7,
      -9, -1, -8.5, -0.5, -7.3, -0.5, -7.4, 0, -6.8, 0.6,
      -5, 1.5, -4, 1.5, -3, 1.5, -2, 1.2, -0.2, 0.6, 0, 0.3, 0, 0
    };
    super.drawShape(vertices);

    fill(0);
    ellipse(-0.8, -0.3, 0.3, 0.3); //eye

    fill(255);
    ellipse(0, 0, 0.25, 0.25); //nose

    stroke(255); //change to white
    strokeWeight(abs(a)/20 * 0.1);
    line(0, 0, 0.5, 0.5);
    line(0, 0, 0.2, 0.8);
    line(0, 0, -0.1, 0.9);
    line(0, 0, -0.3, 0.8);

    popMatrix();
  }
}
