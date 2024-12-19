import processing.sound.SoundFile;

public class Pinniped extends AnimatedObject {
  // Set by the child classes
  float oxygenLevel;
  float oxygenCapacity;
  int preferedDepth;
  SoundFile growlSound;

  int xDirection;
  private int surfaceY;
  private boolean hasAscended;
  private float sineCount;
  boolean nightime;

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

  void mouseWasPressed() {
    if (mouseX > x && mouseX < x + size && mouseY > y && mouseY < y + size)
      xDirection *= -1; // Change direction on click
  }

  boolean nearOtherPinniped(AnimatedObject objs[]) {
    for (AnimatedObject obj : objs) {
      if (obj instanceof Pinniped) {
        Pinniped cast = (Pinniped) obj;
        if (cast.x == x || cast.y == y) continue; // skip ourselves
        float distance = sqrt(pow(cast.x - x, 2) + pow(cast.y - y, 2));
        if (distance < 80)
          return true;
      }
    }
    return false;
  }

 // React to neaby pinnipeds
  void react(AnimatedObject[] objects) {
    if (!nearOtherPinniped(objects)) return;
    growlSound.play();
  }

  void sleep() {
    // Descend from the surface after sleeping
    if (!nightime && hasAscended) {
      y += ySpeed;
      if (y >= preferedDepth)
        hasAscended = false;
      return;
    }

    if (y > surfaceY) {
      y -= ySpeed; // Move to the surface
    } else {
      hasAscended = true;
      // Then do nothing and stay stationary
    }
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
    boolean descendingFromSleep = oxygenLevel > 0 && hasAscended;
    if (nightime || descendingFromSleep)
      sleep();
    else if (oxygenLevel < 0)
      surfaceForAir();
    else
      swim();
  }
}
