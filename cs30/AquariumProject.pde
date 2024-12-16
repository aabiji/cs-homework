import processing.sound.SoundFile;

public class Pinniped extends AnimatedObject {
  int preferedDepth; // in meters
  float oxygenLevel;
  boolean surfacing;

  PVector frontFlipperSize;
  PVector backFlipperSize;
  SoundFile growlSound;

  Pinniped(float size) {
    super();
    this.size = size;

    xSpeed = 5; // temporary -- move into child classes

    oxygenLevel = 1;
    preferedDepth = height / 2;
    surfacing = false;
    
    frontFlipperSize = new PVector(0, 0);
    backFlipperSize = new PVector(0, 0);
    growlSound = null;
  }

  void move() {
    x += xSpeed;
    ySpeed = sin(x) * 5;
    swim();
    y += ySpeed;
  }

  void surfaceAction() {
    ySpeed = abs(ySpeed) * -1;
  }

  void sleep() {}

  void display() {
    rect(x, y, 20, 20);
  }

  void swim() {
    oxygenLevel -= 0.1;
    if (oxygenLevel < 0) surfacing = true;
    if (y < 0) surfacing = false;
    surfaceAction();
 }
}

/** A super class for animated objects 
    Do NOT modify
    Rather, inherit from this class.
    */
class AnimatedObject {
  
  /** Location fields inherited by all subclass */
  float x, y;
  float xSpeed, ySpeed;
  
  /** Size parameter inherited by subclass */
  float size = 50;
  
  /** Constructor
   *  Note that your constructor should accept a single float specifying the size, which will overwrite the inherited default value 50
   *  In addition, your constructor should initialize x and y to a starting location where your creature will appear
   */
  
  /** Displays the object
   *  Note: Implement only one of the display() functions in your subclass, but NOT both.
   *  The second method is used if you want to do collision detection with other objects created by other students
   *  You will then have access to the array of all AnimatedObjects
   */
  void display() { }
  void display( AnimatedObject[] objs ) { display(); }

  boolean isDead() {return false;}

  /** Interactivity functions 
   *  Implement these methods in your class to receive mouse and key clicks
   */
  void mouseWasPressed() { }
  void keyWasPressed() { }
  
  /** Advances the object's animation by one frame 
   */
  void move() { }

  /* Methods that provide access to class data fields */
  float getX() {return x;}
  float getY() {return y;}
  float getSize() {return size;}
  float getxSpeed() {return xSpeed;}
  float getySpeed() {return ySpeed;}
}
import processing.sound.SoundFile;

public class LeopardSeal extends Pinniped {
  int preferedDepth;
  float oxygenLevel;
  PVector frontFlipperSize;
  PVector backFlipperSize;
  SoundFile growlSound;

  LeopardSeal(float size) {
    super(size);
    this.size = size;

    oxygenLevel = 1;
    preferedDepth = 15;
    frontFlipperSize = new PVector(7, 4); // todo: fix this
    backFlipperSize = new PVector(0, 0);
    growlSound = null;
  }

  void move() {
    x += xSpeed;
    y += ySpeed;
  }

  void display() { }
  void display( AnimatedObject[] objs ) { display(); }

  void surface() {} // Come up for air
  void sleep() {}
  void swim() {}
}

Pinniped p;

void setup() {
  size(600, 500);
  p = new Pinniped(100);
}

void draw() {
 background(255); 
 p.move();
 p.display();
}
