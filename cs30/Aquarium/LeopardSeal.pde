import processing.sound.SoundFile;

public class LeopardSeal extends Pinniped {
  int preferedDepth;
  float oxygenLevel;

  PVector velocity;
  int xDirection;
  float maxY, minY;

  SoundFile growlSound;

  LeopardSeal(float size) {
    super(size);

    y = preferedDepth = 200;
    xSpeed = 3; // temporary -- move into child classes
    ySpeed = 1;
    velocity = new PVector(xSpeed, ySpeed);
    growlSound = null;
  }

  void display() {
    rect(x, y, size, size);
  }
}
