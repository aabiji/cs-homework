
int clock = 0;
boolean nightime = false;

// Cycle between daytime and nightime then notify all pinnipeds
void cycleDayNight() {
  if (++clock < 100) return; // Each day is 4000 ticks long
  clock = 0;
  nightime = !nightime;
  for (AnimatedObject obj : objs) {
    if (obj instanceof Pinniped) {
      Pinniped cast = (Pinniped) obj;
      cast.nightime = nightime;
    }
  }
}

void drawTankBackground() {
  cycleDayNight();
}

/** The array of objects */
AnimatedObject[] objs = new AnimatedObject[1];

/** Constant for the sandHeight */
int SAND_HEIGHT = 40;

/** Setup the sketch */
void setup() {
  size(800,600);
  smooth();

  // initialize all the objects
  for (int i=0; i < objs.length; i++) {
    objs[i] = new LeopardSeal(random(30,50));
  }
}

/** The main draw loop */
void draw() {

  // draw the tank background
  background(50,50,255);

  // draw the sandy bottom of the tank
  fill(168,168,50);
  rect(0,height-SAND_HEIGHT, width, SAND_HEIGHT);

  // draw the enhanced tank background, this is mandatory
  drawTankBackground();

  // draw and animate each of the objects
  for (int i=0; i<objs.length; i++) {
    objs[i].display(objs);
    objs[i].move();
  }
}

void mousePressed()
{
  // draw and animate each of the objects
  for (int i=0; i<objs.length; i++) {
    objs[i].mouseWasPressed();
  }
}

void keyPressed()
{
  // draw and animate each of the objects
  for (int i=0; i<objs.length; i++) {
    objs[i].keyWasPressed();
  }
}