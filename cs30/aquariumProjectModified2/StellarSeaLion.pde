import processing.sound.SoundFile;

public class StellarSeaLion extends Pinniped {
  StellarSeaLion(float size) {
    super(size);

    xSpeed = 3;
    ySpeed = 3;
    y = preferedDepth = 475;
    oxygenLevel = oxygenCapacity = 1.6;
  }

  void display(AnimatedObject objs[]) {
    if (super.isClose(objs)) {
      growlSound.play();
      xDirection *= -1;
    }
    fill(143, 26, 163);
    rect(x, y, size, size);
  }
}
