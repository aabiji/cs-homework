
public class PacificWalrus extends Pinniped {
  PacificWalrus(float size) {
    super(size);
    xSpeed = 1;
    ySpeed = 1;
    y = preferedDepth = 300;
    oxygenLevel = oxygenCapacity = 1.0;
  }

  void display(AnimatedObject[] objects) {
    super.react(objects);
    super.updateFlip();

    noStroke();
    pushMatrix();
    translate(x, y);
    rotate(radians(flip ? 350 : 10));
    scale(xDirection * size, size);

    // Draw the body (including head, back and front flippers)
    float[] vertices = {
      0, 0, 4, 0, 4, 0.5, 4.5, 2, 5.5, 1, 6, -0.5, 6.5,-1,
      7, -2, 7.5, -3, 7, -4, 6, -4, 5, -3, 4, -2.5, 0, -2,
     -1, -1, -2, -2, -1, -2.5, 0, -2, -1, -1, -2, 0, -1, 1, 0, 0
    };
    fill(131, 67, 51); // brown
    super.drawShape(vertices);

    // Draw the nose and side eye
    fill(0, 0, 0);
    rect(7.25, -3, 0.25, 0.25);
    rect(6.5, -3.5, 0.4, 0.4);

    // Draw tusks
    fill(255, 255, 255);
    rect(7.25, -3, 0.2, 2);
    rect(6.75, -3, 0.2, 2);

    popMatrix();
  }
}
