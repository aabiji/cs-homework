
public class BeardedSeal extends Pinniped {
  int flipCounter;
  boolean flip;
  
  BeardedSeal(float size) {
    super(size);

    xSpeed = 2;
    ySpeed = 2;
    y = preferedDepth = 400;
    flip = false;
    flipCounter = 0;
    oxygenLevel = oxygenCapacity = 2.5;
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
  noStroke();
  pushMatrix();
  translate(x, y);
  scale(a, abs(a));
  fill(150);
  beginShape();
  vertex(0, 0); //nose
  vertex(-0.2, -0.8);
  vertex(-1, -1);
  vertex(-2, -0.9);
  vertex(-4, -1);
  vertex(-5.3, -0.8);
  vertex(-6, -0.6);
  vertex(-7, 0);
  vertex(-8, 1);
  
  vertex(-8.5, 0.7);
  vertex(-9, 0);
  vertex(-8.4, 0.2);
  vertex(-8, 1);
  vertex(-8.5, 1.2);
  vertex(-9, 2);
  vertex(-8.2, 1.4);
  vertex(-8, 1);
  
  vertex(-7, 1.4);
  vertex(-5, 1.7);
  vertex(-4, 1.7);
  vertex(-3.4, 1.6);
  vertex(-2, 1);
  vertex(-1.3, 0.8);
  vertex(-0.8, 0.8);
  vertex(-0.3, 0.5);
  vertex(0,0);
  endShape();
  
  fill(0);
  ellipse(-0.8, -0.5, 0.3, 0.3); //eye
  fill(255);
  ellipse(0, -0.2, 0.25, 0.25); //nose
  
  stroke(255); //change to white
  strokeWeight(abs(a)/20 * 0.1);
  line(0, -0.2, 0.4, 0.6);
  line(0, -0.2, 0.3, 0.9);
  line(0, -0.2, -0.2, 1);
  line(0, -0.2, -0.4, 0.9);
  
  popMatrix();
}

void secondPose(int a, float x, float y)
{
  noStroke();
  pushMatrix();
  translate(x, y);
  scale(a, abs(a));
  fill(150);
  
  beginShape();
  vertex(0, 0);
  vertex(-0.3, -0.7);
  vertex(-1, -0.9);
  vertex(-1.4, -0.8);
  vertex(-2, -0.4);
  vertex(-3, -0.8);
  vertex(-4, -1);
  vertex(-5, -1);
  vertex(-6, -0.6);
  
  //fixed
  vertex(-7.3, -0.5);
  vertex(-7.5, -1.5);
  vertex(-8, -2);
  vertex(-8, -1.5);
  vertex(-7.3, -0.5);
  vertex(-8, -0.7);
  vertex(-9, -1);
  vertex(-8.5, -0.5);
  vertex(-7.3, -0.5);
  
  vertex(-7.4, 0);
  vertex(-6.8, 0.6);
  vertex(-5, 1.5);
  vertex(-4, 1.5);
  vertex(-3, 1.5);
  vertex(-2, 1.2);
  vertex(-0.2, 0.6);
  vertex(0, 0.3);
  vertex(0, 0);
  endShape();
  
  fill(0);
  ellipse(-0.8, -0.3, 0.3, 0.3); //eye
  
  fill(255);
  ellipse(0, 0, 0.25, 0.25); //nose
  
  stroke(255); //change to white
  strokeWeight(abs(a)/20 * 0.1);
  line(0, 0, 0.5, 0.5);
  line(0, 0, 0.2, 0.8);
  line(0, 0, -0.1, 0.9);
  line(0, 0, -0.3, 0.8);
  
  popMatrix();
}

  
}
