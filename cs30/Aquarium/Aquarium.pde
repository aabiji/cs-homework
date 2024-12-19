Background bg = new Background();

void drawTankBackground() {
  bg.draw(objs);
}

/** The array of objects */
AnimatedObject[] objs = new AnimatedObject[4];

/** Constant for the sandHeight */
int SAND_HEIGHT = 40;

/** Setup the sketch */
void setup() {
  size(800,600);
  smooth();

  SoundFile[] sounds = {
    new SoundFile(this, "BeardedSeal.mp3"),
    new SoundFile(this, "LeopardSeal.mp3"),
    new SoundFile(this, "Walrus.mp3"),
    new SoundFile(this, "SeaLion.mp3")
  };

  objs[0] = new BeardedSeal(20);
  objs[1] = new LeopardSeal(75);
  objs[2] = new PacificWalrus(75);
  objs[3] = new StellarSeaLion(20);

  for (int i = 0; i < objs.length; i++) {
    Pinniped cast = (Pinniped) objs[i];
    cast.growlSound = sounds[i];
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
