//import processing.sound.SoundFile;

public class Pinniped extends AnimatedObject {
  // Set by the child classes
  float oxygenLevel;
  float oxygenCapacity;
  int preferedDepth;
  //SoundFile growlSound;

  private int surfaceY;
  private boolean hasAscended;
  private float sineCount;
  private int xDirection;
  private boolean nightime;

  Pinniped(float size) {
    super();
    this.size = size;
    surfaceY = 100;
    sineCount = 0;
    hasAscended = false;
    nightime = false;
    xDirection = 1; // going right
    x = (int)random(0, width - size);
  }

  //void growl() {
  //  growlSound.play();
  //}

  void sleep() {
    if (y > surfaceY) {
      y -= ySpeed; // Move to the surface
    }
    // The else in this case is to just do nothing and stay stationary
  }

  void surfaceForAir() {
    if (y > surfaceY && !hasAscended)
      y -= ySpeed; // Ascend
    else { // Descend
      hasAscended = true;
      y += ySpeed;
    }

    if (y > preferedDepth && hasAscended) {
      oxygenLevel = oxygenCapacity;
      hasAscended = false;
    }
  }

  // Move the animal in an osciallating fashion
  void swim() {
    x += xSpeed * xDirection;
    if (x >= width - size || x <= 0) {
      xDirection *= -1; // Bounce off side walls
    }

    sineCount += 0.05;
    y = preferedDepth + sin(sineCount) * 50;
    y = max(0, y);
  }

  void move() {
    oxygenLevel -= nightime ? 0 : 0.001;
    if (nightime)
      sleep();
    else if (oxygenLevel < 0)
      surfaceForAir();
    else
      swim();
  }
}
