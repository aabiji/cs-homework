
public class LeopardSeal extends Pinniped {
  LeopardSeal(float size) {
    super(size);
    xSpeed = 4;
    ySpeed = 4;
    y = preferedDepth = 200;
    oxygenLevel = oxygenCapacity = 2.5;
  }

  void display(AnimatedObject[] objects) {
    super.react(objects);
    super.updateFlip();

    noStroke();
    pushMatrix();
    translate(x, y);
    rotate(radians(flip ? 355 : 5));
    scale(xDirection * size, size);

    // Draw body (including the body, head and front and black flippers)
    float[] vertices = {
      0, 0, 3, -1.25, 6, -1.5, 7, -1.75, 8, -1,
      7, 0.05, 6, 0, 5, 1, 4.75, 0.5, 4.5, 0,
      4, 0.25, 0, 0, 0, -0.5, -0.25, -1, -0.5, -0.5,
      0, 0, 0, 0.5, -0.25, 1, -0.5, 0.5, 0, 0
    };
    fill(148, 148, 148); // silver
    super.drawShape(vertices);

    // Draw the nose and side eye
    fill(0, 0, 0); // black
    rect(7.8, -1, 0.25, 0.25);
    rect(7, -1.25, 0.4, 0.4);

    // Draw freckles
    fill(128, 128, 128); // grey
    ellipse(3, -0.5, 0.9, 0.9);
    ellipse(5, -0.75, 0.8, 0.8);
    ellipse(6, -1, 0.3, 0.3);
    ellipse(5, 0.5, 0.4, 0.4);

    popMatrix();
  }
}
