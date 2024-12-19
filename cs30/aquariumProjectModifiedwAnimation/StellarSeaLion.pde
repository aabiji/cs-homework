
public class StellarSeaLion extends Pinniped {
  int flipCounter;
  boolean flip;
  
  StellarSeaLion(float size) {
    super(size);

    xSpeed = 3;
    ySpeed = 3;
    y = preferedDepth = 475;
    oxygenLevel = oxygenCapacity = 1.6;
    flipCounter = 0;
  }

  void display(AnimatedObject objs[]) {
    super.react(objs);
    
    if(flip)firstPose(int(size * xDirection), x, y);
    else secondPose(int(size * xDirection), x, y);
    
    //better way to do this??
    if(flipCounter == 20)
    {
      flip = !flip;
      flipCounter = 0;
    }
    else if(y > 100)
    {
      flipCounter++;
    }
    
  }

  void firstPose(int a, float x, float y)
  {
    pushMatrix();
    translate(x, y);
    scale(a, abs(a));
    fill(129, 111, 46);
    noStroke();
    
    beginShape();
    vertex(0, 0);
    vertex(-0.2, -0.2);
    vertex(-0.4, -0.2);
    vertex(-0.5, -0.7);
    vertex(-1, -1);
    vertex(-1.6, -1);
    vertex(-2, -0.5);
    vertex(-2.8, -0.6);
    vertex(-3.6, -0.4);
    vertex(-4, -2.7);
    vertex(-5, -1.3);
    vertex(-4.4, 0);
    vertex(-5, 0.5);
    vertex(-5.7, 1.3);
    vertex(-6.4, 2.5);
    vertex(-6.5, 3);
    vertex(-8, 3.7);
    vertex(-7.3, 4.4);
    vertex(-6.2, 3.4);
    vertex(-6.4, 4.8);
    vertex(-5.3, 4.8);
    vertex(-5.8, 3.3);
    vertex(-5, 3);
    vertex(-3.7, 2.1);
    vertex(-3.8, 3.5);
    vertex(-2, 4.5);
    vertex(-2.8, 1.8);
    vertex(-1.6, 1.2);
    vertex(-1.3, 0.6);
    vertex(-0.8, 0.7);
    vertex(-0.2, 0.3);
    vertex(0, 0);
    endShape();
    
    strokeWeight(abs(a)/20 * 0.03);
    stroke(255);
    line(-0.3, 0.2, -0.5, 0.4);
    line(-0.2, 0.2, -0.4, 0.5);
    line(-0.1, 0.2, -0.3, 0.6);
    
    noStroke();
    fill(0);
    ellipse(-1, -0.5, 0.3, 0.3); //eye
    ellipse(-0.2, 0, 0.4, 0.3); //nose
    
    popMatrix();
  }
  
  void secondPose(int a, float x, float y)
  {
    pushMatrix();
    translate(x, y);
    scale(a, abs(a));
    noStroke();
    fill(129, 111, 46);
    
    beginShape();
    vertex(0, 0);
    vertex(-0.2, -0.1);
    vertex(-0.5, 0.2);
    vertex(-1, 0);
    vertex(-1.5, 0);
    vertex(-2, 0.4);
    vertex(-3, 0.5);
    vertex(-3.5, -2);
    vertex(-4.8, -1);
    vertex(-4, 0.5);
    vertex(-5, 0.5);
    vertex(-6, 0.2);
    vertex(-6.5, 0);
    vertex(-6, -2);
    vertex(-7, -1.7);
    vertex(-7, 0);
    vertex(-8, -1.2);
    vertex(-8.5, -0.3);
    vertex(-7, 0.3);
    vertex(-6.8, 1.2);
    vertex(-6.4, 2);
    vertex(-5.3, 2.7);
    vertex(-4, 3);
    vertex(-4.5, 4);
    vertex(-3.5, 5.2);
    vertex(-3, 3);
    vertex(-2, 2.8);
    vertex(-0.8, 1.4);
    vertex(-0.2, 0.8);
    vertex(0.1, 0.2);
    vertex(0, 0);
    endShape();
    
    
    strokeWeight(abs(a)/20 * 0.03);
    stroke(255);
    line(-0.3, 0.2, -0.5, 0.4);
    line(-0.2, 0.2, -0.4, 0.5);
    line(-0.1, 0.2, -0.3, 0.6);
    
    noStroke();
    fill(0);
    ellipse(-1.2, 0.2, 0.3, 0.3); //eye
    ellipse(-0.15, 0.1, 0.4, 0.3); //nose
    
    popMatrix();
  }
  
}
