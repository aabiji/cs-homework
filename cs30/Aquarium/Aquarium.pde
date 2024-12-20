/*
Aquarium
--------
Annalise
Abigail Adegbiji
- December 20, 2024

Program that simulates an aquatic environment featuring pinnipeds
like stellar sea lions, pacific walrus', leopard seals and bearded
seals. Each pinniped has their own specific attributes, such as
their oxygen capacity, prefered depth, speed and appearance. When
they are in a certain distance of each other they react by growling
and when its night time they come to the surface to sleep. Periodically
they surface for air. The aquarium observes a day/night cycle and the
ocean background is animated with seaweed.

All sound effects were taken from here:
https://quicksounds.com/library/sounds/seal
*/

Background bg = new Background();

void drawTankBackground() {
  bg.draw(objs);
}

void createAnimals() {
  SoundFile[] sounds = {
    new SoundFile(this, "BeardedSeal.mp3"),
    new SoundFile(this, "LeopardSeal.mp3"),
    new SoundFile(this, "Walrus.mp3"),
    new SoundFile(this, "SeaLion.mp3")
  };

  objs[0] = new BeardedSeal(15);
  objs[1] = new LeopardSeal(15);
  objs[2] = new PacificWalrus(15);
  objs[3] = new StellarSeaLion(15);

  for (int i = 0; i < objs.length; i++) {
    Pinniped cast = (Pinniped) objs[i];
    cast.growlSound = sounds[i];
  }
}

/** The array of objects */
AnimatedObject[] objs = new AnimatedObject[4];

/** Constant for the sandHeight */
int SAND_HEIGHT = 40;

/** Setup the sketch */
void setup() {
  size(800,600);
  smooth();
  createAnimals();
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
