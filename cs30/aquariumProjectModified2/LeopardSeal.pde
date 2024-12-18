import processing.sound.SoundFile;

public class LeopardSeal extends Pinniped {
  LeopardSeal(float size) {
    super(size);

    xSpeed = 4;
    ySpeed = 4;
    y = preferedDepth = 200;
    oxygenLevel = oxygenCapacity = 2.5;
  }

  void display(AnimatedObject objs[]) {
    if (super.isClose(objs)) {
      growlSound.play();
      xDirection *= -1;
    }
    fill(242, 238, 10);
    rect(x, y, size, size);
  }
}
