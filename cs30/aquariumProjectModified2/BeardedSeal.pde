import processing.sound.*;

public class BeardedSeal extends Pinniped {
  BeardedSeal(float size) {
    super(size);

    xSpeed = 2;
    ySpeed = 2;
    y = preferedDepth = 400;
    oxygenLevel = oxygenCapacity = 2.5;
  }

  void display(AnimatedObject objs[]) {
    if (super.isClose(objs)) {
      growlSound.play();
      xDirection *= -1;
    }
    fill(237, 19, 19);
    rect(x, y, size, size);
  }
}
