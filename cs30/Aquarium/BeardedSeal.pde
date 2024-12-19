
public class BeardedSeal extends Pinniped {
  BeardedSeal(float size) {
    super(size);

    xSpeed = 2;
    ySpeed = 2;
    y = preferedDepth = 400;
    oxygenLevel = oxygenCapacity = 2.5;
  }

  void display(AnimatedObject[] objects) {
    super.react(objects);
    fill(237, 19, 19);
    rect(x, y, size, size);
  }
}
