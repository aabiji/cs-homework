//import processing.sound.SoundFile;

public class LeopardSeal extends Pinniped {
  //SoundFile growlSound;

  LeopardSeal(float size) {
    super(size);

    xSpeed = 1;
    ySpeed = 5;
    y = preferedDepth = 300;
    oxygenLevel = oxygenCapacity = 1.0;
    //growlSound = null;
  }

  void display() {
    rect(x, y, size, size);
  }
}
