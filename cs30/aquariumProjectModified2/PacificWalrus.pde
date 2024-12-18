import processing.sound.SoundFile;

public class PacificWalrus extends Pinniped {
  PacificWalrus(float size) {
    super(size);

    xSpeed = 1;
    ySpeed = 1;
    y = preferedDepth = 300;
    oxygenLevel = oxygenCapacity = 1.0;
  }

 void display(AnimatedObject objs[]) {
    if (super.isClose(objs)) {
      growlSound.play();
      xDirection *= -1;
    }
    fill(18, 222, 31);
    rect(x, y, size, size);
  }
}
