//import processing.sound.SoundFile;

boolean isNight = false;

public class Pinniped extends AnimatedObject {
  float oxygenLevel;
  float oxygenCapacity;
  int preferedDepth;
  //SoundFile growlSound;

  private int surfaceY;
  private boolean hasAscended;
  private float sinCount;
  private int xDirection;

  int clock;

  Pinniped(float size) {
    super();
    this.size = size;

    surfaceY = 10;
    hasAscended = false;
    sinCount = 0;
    xDirection = 1; // going right
    x = (int)random(0, width - size);

    clock = 0;

    // These should be set by child classes
    y = 0;
    xSpeed = 0;
    ySpeed = 0;
    preferedDepth = 0;
    //growlSound = null;
    oxygenLevel = 0;
    oxygenCapacity = 0;
  }

  //void growl() {
  //  growlSound.play();
  //}

  // Go to the surface then stay stationary
  void sleep() {
    if (y > surfaceY) {
      y -= ySpeed;
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

    sinCount = sinCount + 0.05;
    y = preferedDepth + sin(sinCount) * 50;
    y = max(0, y);
  }

  void move() {
    oxygenLevel -= isNight ? 0 : 0.001;
    if (isNight)
      sleep();
    else if (oxygenLevel < 0)
      surfaceForAir();
    else
      swim();

    // TODO: this should go into the background
    clock ++;
    println(clock);
    if (clock == 2000) {
      isNight = !isNight;
      clock = 0;
    }
  }
}
