

class SpriteAnimation {
  PImage[] images;
  int currentFrame;
  int count;

  SpriteAnimation() {
     images = new PImage[1];
     currentFrame = 0;
     count = 0;
  }

  // Load only 1 image so the animation is really a static image
  SpriteAnimation(String imagePath) {
     currentFrame = 0;
     count = 0;
     images = new PImage[1];
     images[0] = loadImage(imagePath);
  }

  // Load multip-le images
  void loadFrames(String[] files) {
    images = new PImage[files.length];
    for (int i = 0; i < files.length; i++) {
      PImage img = loadImage(files[i]);
      images[i] = img;
    }
  }

  void render(int x, int y, float rotation) {
    pushMatrix();  
    translate(x, y);
    rotate(rotation);
    image(images[currentFrame], 0, 0);
    popMatrix();

    // Change the animation frame every 5 frames
    count++;
    if (count % 5 == 0) {
      currentFrame = (currentFrame+1) % images.length;
      count = 0;
    }
  }
}

class Bird {
  int y;
  int rotation;
  SpriteAnimation animation;

  Bird() {
    y = 0;
    String[] files = {"bird1.png", "bird2.png", "bird3.png"};
    animation = new SpriteAnimation();
    animation.loadFrames(files);
  }

  void update() {
    y += 2; // fall
    rotation = min(rotation + 1, 90); // tilt downwards
    if (mousePressed) {
      y -= 10; // jump up
      rotation = min(rotation - 2, 0);
    }

    // clamp position
    if (y < 0) y = 0;
    if (y > height - 15) y = height - 15; // TODO: game over
  }

  void render() {
    animation.render(width / 2, y, radians(rotation));
  }
}

class PipePair {
  int x;
  int resetX;

  int pipeWidth;
  int pipeGap; // gap in between the 2 pipes

  int upperPipeHeight;
  int lowerPipeHeight;
  SpriteAnimation pipe;

  PipePair(int startX, int gap, int offset) {
    x = startX;
    pipeGap = gap;
    resetX = width + offset;
    pipeWidth = 35;
    initPipes();
  }
  
  void initPipes() {
    lowerPipeHeight = (int)random(height / 4, height - pipeGap*2);
    upperPipeHeight = height - lowerPipeHeight - pipeGap;
    pipe = new SpriteAnimation("pipe.png");
  }

  void scrollLeft(int speed) {
    x -= speed; // scroll left
    if (x < -pipeWidth * 2) {
      // wrap back around if we're off the screen
      x = resetX;
      initPipes();
    }
  }
  
  void render() {
    // Draw the upper and lower pipes
    pipe.render(x + 50, upperPipeHeight, radians(180));
    pipe.render(x, height - lowerPipeHeight + pipeGap, 0);
  }
  
  boolean hasCollided(Bird bird) {return false;}
}

Bird bird;
PipePair[] pipes;
SpriteAnimation background;

void setup() {
  size(285, 400);
  bird = new Bird();
  pipes = new PipePair[3];
  for (int i = 0; i < pipes.length; i++) {
    int gap = 160;
    int x = (int)(width*1.5) + i*gap;
    pipes[i] = new PipePair(x, 50, gap);
  }
  background = new SpriteAnimation("background.png");
}

void draw() {
  background.render(0, 0, 0);
  bird.update();
  bird.render();
  for (int i = 0; i < pipes.length; i++) {
    pipes[i].scrollLeft(1);
    pipes[i].render();
  }
}
