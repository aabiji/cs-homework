

class Bird {
  int y;
  Bird() {
     y = 0;
  }

  void update() {
    y += 2; // fall
    if (mousePressed)
      y -= 10; // jump up
      
    // clamp position
    if (y < 0) y = 0;
    if (y > height - 15) y = height - 15; // TODO: game over

    // tilt bird downwards
    /* rotate around (100, 100)
      background(0);
      pushMatrix();
      translate(100, 100);
      rotate(radians(angle));
      rect(0, 0, 25, 75);
      popMatrix();
    */

    fill(255, 165, 0);
    bird.y += 1;
    rect(width / 2, bird.y, 15, 15);
  }
}

class PipePair {
  int x;
  int resetX;
  int upHeight;
  int downHeight;
  int pipeWidth;
  int pipeGap; // gap in between the 2 pipes

  PipePair(int startX, int gap, int offset) {
    x = startX;
    pipeGap = gap;
    resetX = width + offset/2;
    pipeWidth = 35;
    initPipes();
  }
  
  void initPipes() {
    downHeight = (int)random(height / 4, height - pipeGap);
    upHeight = height - downHeight - pipeGap;
  }

  void scrollLeft(int speed) {
    x -= speed; // scroll left
    if (x < -pipeWidth) {
      // wrap back around if we're off the screen
      x = resetX;
      initPipes();
    }
  }
  
  void render() {
    // Draw the upper and lower pipes
    fill(120, 189, 52);
    rect(x, 0, pipeWidth, upHeight);
    int y = height - downHeight + pipeGap;
    rect(x, y, pipeWidth, downHeight);
  }
  
  boolean hasCollided(Bird bird) {return false;}
}

Bird bird;
PipePair[] pipes;

void setup() {
  size(400, 400);
  bird = new Bird();
  pipes = new PipePair[4];
  for (int i = 0; i < pipes.length; i++) {
    int x = (int)(width*1.5) + i*120;
    pipes[i] = new PipePair(x, 50, 120);
  }
}

void draw() {
  background(112, 196, 204);  
  bird.update();
  for (int i = 0; i < pipes.length; i++) {
    pipes[i].scrollLeft(1);
    pipes[i].render();
  }
}
