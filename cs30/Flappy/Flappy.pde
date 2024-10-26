/*
Flappy
------
Abigail Adegbiji
October 25, 2024

A basic flappy bird clone. Click to flap, and press any key to restart the game.
Assets taken from here: https://github.com/samuelcust/flappy-bird-assets/tree/master/sprites
*/

class SpriteAnimation {
  int count;
  int currentFrame;
  PImage[] frames;

  // Constructor for loading multiple images paired with the loadFrames function
  SpriteAnimation() {
     frames = new PImage[1];
     currentFrame = 0;
     count = 0;
  }

  // Constructor for loading a single image as a static animation
  SpriteAnimation(String imagePath) {
     currentFrame = 0;
     count = 0;
     frames = new PImage[1];
     frames[0] = loadImage(imagePath);
  }

  void loadFrames(String[] files) {
    frames = new PImage[files.length];
    for (int i = 0; i < files.length; i++) {
      frames[i] = loadImage(files[i]);
    }
  }

  int width() {
    return frames[currentFrame].width;
  }

  int height() {
    return frames[currentFrame].height;
  }

  void render(int x, int y, int rotation) {
    // Render the rotated frame properly
    pushMatrix();
    translate(x + width() / 2, y + height() / 2);
    rotate(radians(rotation));
    image(frames[currentFrame], -width()/2, -height()/2);
    popMatrix();

    // Change the animation frame every 5 frames
    count++;
    if (count % 5 == 0) {
      currentFrame = (currentFrame + 1) % frames.length;
      count = 0;
    }
  }
}

// A rectangle representing a sprite that's useful for collision detection
class BoundingBox {
  PVector[] edges;
  PVector[] vertices;
  int x, y, w, h, rotation;

  BoundingBox(int boxWidth, int boxHeight) {
    w = boxWidth;
    h = boxHeight;
    x = y = rotation = 0;
    edges = new PVector[4];
    vertices = new PVector[4];
  }

  // Calculate the vertices of our rectangle, accounting for rotation
  void calculateVertices() {
    // Top right, bottom right, bottom left, top left vertex positions if the center was (0, 0)
    float[][] localPosition = {{w / 2, -h / 2}, {w / 2, h / 2}, {-w / 2, h / 2}, {-w / 2, -h / 2}};
    float theta = radians(rotation);
    int centerX = x + w/2;
    int centerY = y + h/2;
    for (int i = 0; i < 4; i++) {
      float[] point = localPosition[i];
      float rotatedX = point[0] * cos(theta) - point[1] * sin(theta);
      float rotatedY = point[0] * sin(theta) + point[1] * cos(theta);
      vertices[i] = new PVector(rotatedX + centerX, rotatedY + centerY);
    }
  }

  // Calculate the right, bottom, left, top edge (in that order)
  void calculateEdges() {
    edges[0] = new PVector(vertices[1].x - vertices[0].x, vertices[1].y - vertices[0].y);
    edges[1] = new PVector(vertices[2].x - vertices[1].x, vertices[2].y - vertices[1].y);
    edges[2] = new PVector(vertices[3].x - vertices[2].x, vertices[3].y - vertices[2].y);
    edges[3] = new PVector(vertices[3].x - vertices[0].x, vertices[3].y - vertices[0].y);
  }
}

// Use the separating axis theorem to check if the 2 rectangles are colliding.
// The idea behind SAT is that if two convex polygons are not colliding, there's
// at least one axis (line) on which you can project both shapes, and their
// projections will not overlap. If you can find that line, the shapes are
// guaranteed not to collide. Ressources:
// https://stackoverflow.com/questions/62028169/how-to-detect-when-rotated-rectangles-are-colliding-each-other
// https://www.youtube.com/watch?v=Nm1Cgmbg5SQ
boolean intersection(BoundingBox a, BoundingBox b) {
  a.calculateVertices();
  a.calculateEdges();
  b.calculateVertices();
  b.calculateEdges();

  int numAxes = 8;
  int numSides = 4;

  // Get vectors that are perpendicular for each rectangle edge. They are our axes
  PVector[] axes = new PVector[numAxes];
  for (int i = 0; i < numSides; i++) {
    axes[i] = new PVector(a.edges[i].y, -a.edges[i].x);
    axes[i+numSides] = new PVector(b.edges[i].y, -b.edges[i].x);
  }

  for (int i = 0; i < numAxes; i++) {
    // Minimum and maximum dot product for both rectangles
    double a_min = Double.MAX_VALUE;
    double a_max = Double.MIN_VALUE;
    double b_min = Double.MAX_VALUE;
    double b_max = Double.MIN_VALUE;

    // Find the minimum and maximum vertex projections for both rectangles
    // To project the vertex unto the axis we'll use the dot product
    for (int j = 0; j < numSides; j++) {
      double dot = a.vertices[j].dot(axes[i]);
      if (dot < a_min) a_min = dot;
      if (dot > a_max) a_max = dot;

      dot = b.vertices[j].dot(axes[i]);
      if (dot < b_min) b_min = dot;
      if (dot > b_max) b_max = dot;
    }

    // Check if the left edge of the second rectangle overlaps with the
    // right edge of the first rectangle and that the first rectangle comes
    // before the second rectangle. Vice versa for the second rectangle.
    boolean noGap = (b_min < a_max && b_min > a_min) || (a_min < b_max && a_min > b_min);
    if (!noGap) return false; // Found a separating axis.
  }

  return true; // We found no separating axis, so there's a collision
}

class PipePair {
  int x;
  int resetX; // x position off the screen we'll respawn the pipe pair at
  int pipeGap; // size of gap between the upper and lower pipes
  int[] pipeYPositions;
  BoundingBox[] pipeBoxes;
  SpriteAnimation pipe;

  PipePair(int startX, int gap, int resetOffset) {
    x = startX;
    resetX = (int)(width * 0.8) + resetOffset;
    pipeGap = gap;
    pipeYPositions = new int[2];
    pipeBoxes = new BoundingBox[2];
    pipe = new SpriteAnimation("pipe.png");
    initPipes();
  }

  void initPipes() {
    int lowerHeight  = (int)random(height / 4, height - pipeGap * 2);
    int upperHeight   = height - lowerHeight - pipeGap;
    pipeBoxes[0] = new BoundingBox(pipe.width(), upperHeight);
    pipeBoxes[1] = new BoundingBox(pipe.width(), lowerHeight);

    // The pipe is drawn from the y position downwards.
    // Instead of resizing the pipe sprite each time, we'll just
    // adjust the y coordinate to control how much of the sprite
    // is shown on the screen, giving the same effect as resizing.
    pipeYPositions[0] = -(pipe.height() - upperHeight); // upper pipe
    pipeYPositions[1] = height - lowerHeight; // lower pipe
  }

  void scrollLeft(int speed) {
    x -= speed; // scroll left

    // wrap back around if we're off the screen
    if (x < -pipe.width() * 2) {
      x = resetX;
      initPipes();
    }

    // Set the positions of the bounding boxs
    for (int i = 0; i < pipeBoxes.length; i++) {
      pipeBoxes[i].x = x;
      pipeBoxes[i].y = i == 0 ? 0 : pipeYPositions[i];
    }
  }

  // Return true if the upper and lower pipes have gone
  // pass the bird. If so, the bird must not have collided with them
  boolean cleared() {
    int birdX = width / 2;
    int targetX = birdX - pipe.width() / 2;
    return x == targetX;
  }

  void render() {
    for (int i = 0; i < pipeBoxes.length; i++) {
      pipe.render(x, pipeYPositions[i], i == 1 ? 0 : 180);
    }
  }
}

class Bird {
  int x, y;
  int rotation;
  SpriteAnimation animation;
  BoundingBox box;

  Bird() {
    String[] files = {"bird1.png", "bird2.png", "bird3.png"};
    animation = new SpriteAnimation();
    animation.loadFrames(files);

    box = new BoundingBox(animation.width(), animation.height());
    x = box.x = width / 2;
    reset();
  }

  void reset() {
    y = height / 2 - animation.height();
    rotation = 0;
  }

  void update() {
    int fallSpeed = 2;
    int jumpSpeed = 5;
    int tiltSpeed = 1;

    y += fallSpeed;
    rotation = min(rotation + tiltSpeed, 90);
    if (mousePressed) {
      y = max(y - jumpSpeed, 0);
      rotation = min(rotation - tiltSpeed * 2, 0);
    }

    // Update the position and orientation of the bounding box
    box.y = y;
    box.rotation = rotation;
  }

  void render() {
    animation.render(x, y, rotation);
  }

  boolean gameOver(PipePair pair) {
    // Check for collisions between the top and bottom pipes
    for (int i = 0; i < pair.pipeBoxes.length; i++) {
      if (intersection(pair.pipeBoxes[i], box))
        return true;
    }

    // Return true if the bird falls off the screen
    return y > height - animation.height();
  }
}

Bird bird;
PipePair[] pipes;
SpriteAnimation background;
int score = 0;
int highScore = 0;
boolean gameOver = false;

void initPipes() {
  // Initialize the pipes evenly spaced off the screen
  for (int i = 0; i < pipes.length; i++) {
    int gap = 160;
    int x = (int)(width * 1.5) + i * gap;
    pipes[i] = new PipePair(x, 100, gap);
  }
}

void setup() {
  size(285, 400);
  bird = new Bird();
  background = new SpriteAnimation("background.png");
  pipes = new PipePair[3];
  initPipes();
}

void drawText(String str, int x, int y, int size) {
  textSize(size);
  float adjustedX = x - textWidth(str) / 2;
  float adjustedY = y + size / 2;
  text(str, adjustedX, adjustedY, size);
}

void draw() {
  background.render(0, 0, 0);

  if (gameOver) {
    drawText("GAME OVER", width / 2, height / 2 - 50, 40);
    drawText(String.format("High score: %d", highScore), width / 2, height / 2 - 15, 30);
    drawText(String.format("Score: %d", score), width / 2, height / 2 + 20, 25);
    drawText("Press any key to restart", width / 2, height / 2 + 45, 15);

    if (keyPressed) {
      initPipes();
      bird.reset();
      score = 0;
      gameOver = false;
    }
    return;
  }

  bird.update();
  bird.render();

  for (int i = 0; i < pipes.length; i++) {
    pipes[i].scrollLeft(1);

    if (bird.gameOver(pipes[i])) {
      gameOver = true;
      highScore = max(highScore, score);
      break;
    }

    if (pipes[i].cleared())
      score++;

    pipes[i].render();
  }

  drawText(String.format("%d", score), width / 2, 25, 30);
}