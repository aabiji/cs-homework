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
