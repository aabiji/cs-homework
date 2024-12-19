
public class StellarSeaLion extends Pinniped {
  StellarSeaLion(float size) {
    super(size);

    xSpeed = 3;
    ySpeed = 3;
    y = preferedDepth = 475;
    oxygenLevel = oxygenCapacity = 1.6;
  }

  void display(AnimatedObject[] objects) {
    super.react(objects);
    fill(143, 26, 163);
    rect(x, y, size, size);
  }
}
