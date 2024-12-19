
public class PacificWalrus extends Pinniped {
  PacificWalrus(float size) {
    super(size);

    xSpeed = 1;
    ySpeed = 1;
    y = preferedDepth = 300;
    oxygenLevel = oxygenCapacity = 1.0;
  }

  // Draw an isoceles triangle
  void drawTriangle(float x, float y, float base, float len, float angle) {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    triangle(0, 0, 0, base, -len, base/ 2);
    popMatrix();
  }

 void display(AnimatedObject[] objects) {
    super.react(objects);

    noStroke();
    pushMatrix();
    translate(size, 0); // since the ellipse xy is its center

    // Flip layer to face left when needed
    if (xDirection == -1) {
      translate(2 * x, 0); // move everything into view
      scale(-1, 1);
    }

    fill(131, 67, 51); // brown
    ellipse(x, y, size, size / 2); // body
    ellipse(x + size / 3, y - size / 5, size / 2, size/2); // head
    drawTriangle(x, y - size / 10, size / 2.5, size / 2, radians(-85)); // front flipper
    // back flippers
    drawTriangle(x - size / 2.5, y + size / 12, size / 5, size / 5, radians(120));
    drawTriangle(x - size / 2.5, y + size / 6, size / 5, size / 5, radians(120));

    // tusks
    fill(255, 255, 255);
    drawTriangle(x + size / 2.5, y, size / 10, size / 3, radians(-95));
    drawTriangle(x + size / 3.5, y, size / 10, size / 3, radians(-80));

    popMatrix();
  }
}
