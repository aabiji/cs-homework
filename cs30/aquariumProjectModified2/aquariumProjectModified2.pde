
int clock = 0;
boolean nightime = false;

// Cycle between daytime and nightime then notify all pinnipeds
void cycleDayNight() {
  if (++clock < 1000) return; // Each day is 4000 ticks long
  clock = 0;
  nightime = !nightime;
  for (AnimatedObject obj : objs) {
    if (obj instanceof Pinniped) {
      Pinniped cast = (Pinniped) obj;
      cast.nightime = nightime;
    }
  }
}

void drawVerticalGradient(int startY, int endY, color start, color end) {
  int h = endY - startY;
  for (float i = 0; i < 1.0; i += 0.01) {
    noStroke();
    fill(lerpColor(start, end, i));
    rect(0, startY + i * h, width, h * 0.01);
  }
}

// ToDO; animate this
void drawSurface() {
  // draw the sky
  fill(nightime ? color(10, 10, 10) : color(172, 229, 238));
  rect(0, 0, width, 100);
  // draw the moon/sun
  fill(nightime ? color(200, 200, 200) : color(255, 255, 51));
  circle(width - 100, 50, 50);
}

// TODO: make this less awful
// Determine the vertices for seaweed strewn accross the seafloor
ArrayList<PVector> createSeaweed(int x) {
  int h = 50; // segment height
  int numSegments = (int)random(3, 8);
  int y = height - SAND_HEIGHT - numSegments * h;
  ArrayList<PVector> vertices = new ArrayList<PVector>();

  // base
  vertices.add(new PVector(x, y));
  vertices.add(new PVector(x, y));

  // body segments
  for (int j = 0; j < numSegments; j++) {
    vertices.add(new PVector(x + random(-20, 20), y + (j+1) * h));
  }

  // tip
  vertices.add(new PVector(x + random(-20, 20), y + numSegments * h));
  vertices.add(new PVector(x + random(-20, 20), y + numSegments * h));

  return vertices;
}

ArrayList<PVector>[] seaweeds;
void createVegetation() {
  seaweeds = new ArrayList[15];
  for (int i = 0; i < seaweeds.length; i++) {
    seaweeds[i] = createSeaweed(50 + i * 50);
  }
}

void drawTankBackground() {
  cycleDayNight();
  drawVerticalGradient(100, height - SAND_HEIGHT, color(132, 188, 243), color(6, 29, 149));
  drawSurface();

  if (seaweeds == null || clock % 100 == 0) {
    createVegetation(); // TODO: make the seaweeds actually move in a dynamic way
  } else {
    fill(0, 100, 0);
    for (ArrayList<PVector> vertices : seaweeds) {
      beginShape();
      for (PVector v : vertices) {
        curveVertex(v.x, v.y);
      }
      endShape();
    }
  }
}

SoundFile[] sounds;

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
  objs[1] = new LeopardSeal(20);
  objs[2] = new PacificWalrus(20);
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
