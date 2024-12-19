
public class LeopardSeal extends Pinniped {
  LeopardSeal(float size) {
    super(size);

    xSpeed = 4;
    ySpeed = 4;
    y = preferedDepth = 200;
    oxygenLevel = oxygenCapacity = 2.5;
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

    fill(192,192,192); // silver
    drawTriangle(x, y - size / 10, size / 4, size / 3, radians(-45)); // front flipper

    // back flippers
    drawTriangle(x - size / 2.6, y, size / 10, size / 10, radians(120));
    drawTriangle(x - size / 2.6, y + size / 8, size / 10, size / 10, radians(120));

    fill(169, 169, 169); // dark gray
    ellipse(x, y, size, size / 4); // body
    ellipse(x + size / 2, y, size / 4, size / 4); // head

    popMatrix();
  }
}
