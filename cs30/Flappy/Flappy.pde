/*
Flappy
October 25, 2024

A flappy bird clone.
Assets taken from here: https://github.com/samuelcust/flappy-bird-assets/tree/master/sprites
*/

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

  // Load multiple images
  void loadFrames(String[] files) {
    images = new PImage[files.length];
    for (int i = 0; i < files.length; i++) {
      PImage img = loadImage(files[i]);
      images[i] = img;
    }
  }

  int width() {
    return images[currentFrame].width;
  }
  
  int height() {
    return images[currentFrame].height;
  }

  void render(int x, int y, int degrees) {
    pushMatrix();
    translate(x + width() / 2, y + height() / 2);
    rotate(radians(degrees));
    image(images[currentFrame], -width()/2, -height()/2);
    popMatrix();

    // Change the animation frame every 5 frames
    count++;
    if (count % 5 == 0) {
      currentFrame = (currentFrame+1) % images.length;
      count = 0;
    }
  }
}

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
    // Vertex positions if the center was (0, 0)
    // top right, bottom right, bottom left, top left
    float[][] localPosition = {{w/2, -h/2}, {w/2, h/2}, {-w/2, h/2}, {-w/2, -h/2}};
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

  // Calculate the right, bottom, left, top (in that order)
  void calculateEdges() {
    edges[0] = new PVector(vertices[1].x - vertices[0].x, vertices[1].y - vertices[0].y);
    edges[1] = new PVector(vertices[2].x - vertices[1].x, vertices[2].y - vertices[1].y);
    edges[2] = new PVector(vertices[3].x - vertices[2].x, vertices[3].y - vertices[2].y);
    edges[3] = new PVector(vertices[3].x - vertices[0].x, vertices[3].y - vertices[0].y);
  }
}

// Use the separating axis theorem to check if the 2 rectangles are colliding.
// The idea behind SAT is that if two convex polygons are not colliding, there's
// at least one line (axis) on which you can project both shapes, and their
// projections will not overlap. If you can find that line,
// the shapes are guaranteed not to collide.
// Ressources:
// https://stackoverflow.com/questions/62028169/how-to-detect-when-rotated-rectangles-are-colliding-each-other
// https://www.youtube.com/watch?v=Nm1Cgmbg5SQ
boolean intersection(BoundingBox a, BoundingBox b) {
  a.calculateVertices();
  a.calculateEdges();
  b.calculateVertices();
  b.calculateEdges();

  // Get vectors that are perpendicular for each rectangle edge
  // They will be our axes
  PVector[] axes = new PVector[8];
  for (int i = 0; i < 4; i++) {
    axes[i] = new PVector(a.edges[i].y, -a.edges[i].x);
    axes[i+4] = new PVector(b.edges[i].y, -b.edges[i].x);
  }

  for (int i = 0; i < 8; i++) {
    // Minimum and maximum dot product for both rectangles
    double a_min = Double.MAX_VALUE;
    double a_max = Double.MIN_VALUE;
    double b_min = Double.MAX_VALUE;
    double b_max = Double.MIN_VALUE;

    // Find the minimum and maximum vertex projections for both rectangles
    // To project the vertex unto the axis we'll use the dot product
    for (int j = 0; j < 4; j++) {
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

class Bird {
  int y;
  int rotation;
  SpriteAnimation animation;
  BoundingBox box;

  Bird() {
    y = 0;
    String[] files = {"bird1.png", "bird2.png", "bird3.png"};
    animation = new SpriteAnimation();
    animation.loadFrames(files);
    box = new BoundingBox(animation.width(), animation.height());
    box.x = width / 2;
  }

  boolean update() {
    y += 2; // fall
    rotation = min(rotation + 1, 90); // tilt downwards
    if (mousePressed) {
      y -= 10; // jump up
      rotation = min(rotation - 2, 0);
    }

    if (y < 0) y = 0; // Clamp position
    box.y = y;
    box.rotation = rotation;

    // Return true if the bird falls off the screen
    return y > height - animation.height();
  }

  void render() {
    animation.render(width / 2, y, rotation);
  }
}

class PipePair {
  int x;
  int resetX;
  int[] pipeYs;
  BoundingBox[] pipeBoxes;
  SpriteAnimation pipe;
  int pipeGap; // gap in between the 2 pipes

  PipePair(int startX, int gap, int offset) {
    x = startX;
    resetX = width + offset;
    pipeGap = gap;
    pipeYs = new int[2];
    pipeBoxes = new BoundingBox[2];
    initPipes();
  }

  void initPipes() {
    pipe = new SpriteAnimation("pipe.png");

    // Lower pipe
    int pipeHeight  = (int)random(height / 4, height - pipeGap*2);
    pipeBoxes[1] = new BoundingBox(pipe.width(), pipeHeight);
    pipeYs[1] = height - pipeHeight;

    // Upper pipe
    pipeHeight  = height - pipeHeight - pipeGap;
    pipeBoxes[0] = new BoundingBox(pipe.width(), pipeHeight);
    pipeYs[0] = -(pipe.height() - pipeHeight);
  }

  void scrollLeft(int speed) {
    x -= speed; // scroll left
    if (x < -pipe.width() * 2) {
      // wrap back around if we're off the screen
      x = resetX;
      initPipes();
    }

    for (int i = 0; i < pipeBoxes.length; i++) {
      pipeBoxes[i].x = x;
      pipeBoxes[i].y = i == 0 ? 0 : pipeYs[i];
    }
  }

  void render() {
    for (int i = 0; i < pipeBoxes.length; i++) {
      pipe.render(x, pipeYs[i], i == 1 ? 0 : 180);
    }
  }

  boolean didCollide(Bird bird) {
    for (int i = 0; i < pipeBoxes.length; i++) {
      if (intersection(pipeBoxes[i], bird.box))
        return true;
    }
    return false;
  }
}

Bird bird;
PipePair[] pipes = new PipePair[3];
SpriteAnimation background;
boolean gameOver = true;
int score = 0;

void initPipes() {
  for (int i = 0; i < pipes.length; i++) {
    int gap = 160;
    int x = (int)(width*1.5) + i*gap;
    pipes[i] = new PipePair(x, 100, gap);
  } 
}

void setup() {
  size(285, 400);
  bird = new Bird();
  initPipes();
  background = new SpriteAnimation("background.png");
}

void drawText(String str, int x, int y, int size) {
  textSize(size);
  x -= textWidth(str) / 2;
  y += size / 2;
  text(str, x, y, size);
}

void draw() {
  background.render(0, 0, 0);

  if (mousePressed && gameOver) {
    gameOver = false;
    score = 0;
    initPipes();
  }

  if (gameOver) {
    drawText("GAME OVER", width / 2, height / 2 - 50, 40);
    drawText(String.format("SCORE %d", score), width / 2, height / 2 - 15, 30);
    drawText("Click to restart", width / 2, height / 2 + 15, 20);
    return; 
  }

  if (bird.update())
    gameOver = true;
  bird.render();

  for (int i = 0; i < pipes.length; i++) {
    pipes[i].scrollLeft(1);
    pipes[i].render();
    if (pipes[i].didCollide(bird))
      gameOver = true;
  }

  drawText(String.format("%d", score), width / 2, 25, 30);
}
