import processing.sound.SoundFile;

boolean isNight = false;
int previousMinute = -1;

public class Pinniped extends AnimatedObject {
  int preferedDepth;
  float oxygenLevel;

  PVector velocity;
  int xDirection;
  int surfaceY;

  SoundFile growlSound;

  Pinniped(float size) {
    super();
    this.size = size;

    x = (int)random(0, width - size);
    xSpeed = ySpeed = 0;
    xDirection = 1; // right
    velocity = new PVector(0, 0);

    oxygenLevel = 1;
    surfaceY = 10;
  }

  void move() {
    x += velocity.x * xDirection;
    y += velocity.y;

    // TODO: this should go into the background
    if (previousMinute == -1) previousMinute = second();
    int now = second();
    int duration = now - previousMinute;
    if (duration == 15) {
      isNight = !isNight;
      previousMinute = now;
    }

    if(x >= width || x <= 0)
    {
      xDirection *= -1;
    }
  }
  
  void growl() {
    growlSound.play(); 
  }

  void sleep() {
    if (y > surfaceY) {
      velocity.y = -ySpeed;
    } else {
      velocity.x = 0;
      velocity.y = 0;
    }
  }

  void display() {
    rect(x, y, 20, 20);
  }

  void swim() 
  {
    if (isNight) {
      sleep();
      return;
    }

    velocity.x = xSpeed;
    if(oxygenLevel <= 0)
    {
      velocity.y = -ySpeed;
      println("i need o2");
      if(y <= surfaceY)
      {
        oxygenLevel = 1;
      }
    }
    else if(oxygenLevel > 0 && y <= preferedDepth)
    {
      velocity.y = ySpeed;
    }
    else
    {
      velocity.y = sin(x) * ySpeed;
    }
    oxygenLevel -= 0.01;
    
    println(oxygenLevel);
  }
}
