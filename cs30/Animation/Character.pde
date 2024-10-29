enum Action { Default, Run, Attack }

class Character {
  int x, y;
  int directionX;
  int directionY;

  int count;
  int currentFrame;
  int currentAnimation;
  int previousAnimation;

  boolean pauseMovement;
  boolean stopWhenDone;

  // Index by action index, direction index then frame index
  PImage[][][] animations;

  Character(int xpos, int ypos, String[] assetFolders) {
    x = xpos;
    y = ypos;
    directionX = 0;
    directionY = 0;

    count = 0;
    currentFrame = 0;
    currentAnimation = 0;
    previousAnimation = 0;
    loadAnimations(assetFolders);

    stopWhenDone = false;
    pauseMovement = false;
  }

  void loadAnimations(String[] assetFolders) {
    int directions = 8;
    int actions = assetFolders.length;
    animations = new PImage[actions][directions][];

    for (int i = 0; i < actions; i++) {
      for (int j = 0; j < directions; j++) {
        String imgPath = String.format("%s/%d.png", assetFolders[i], j + 1);
        String jsonPath = String.format("%s/%d.json", assetFolders[i], j + 1);
        animations[i][j] = loadSpriteSheet(imgPath, jsonPath);
      }
    }
  }

  PImage[] loadSpriteSheet(String imgPath, String jsonPath) {
    PImage spritesheet = loadImage(imgPath);

    JSONObject json = loadJSONObject(jsonPath);
    JSONArray framesObj = json.getJSONArray("frames");

    int numFrames = framesObj.size();
    PImage[] frames = new PImage[numFrames];

    // Crop portions of the spritesheet into individual frames
    for (int i = 0; i < numFrames; i++) {
      JSONObject object = framesObj.getJSONObject(i);
      JSONObject obj = object.getJSONObject("frame");
      frames[i] = spritesheet.get(
        obj.getInt("x"),
        obj.getInt("y"),
        obj.getInt("w"),
        obj.getInt("h")
      );
    }

    return frames;
  }

  // Get sprite indexes based on the x direction and y direction
  int getDirectionIndex() {
    int[][] indexes = {
      {1, 0, 7}, // Top left, left, bottom left
      {2, 6, 6}, // Top, Bottom, Top
      {3, 4, 5}  // Top right, right, bottom right
    };
    return indexes[directionX + 1][directionY + 1];
  }

  void setAnimation(Action a, boolean stop) {
    if (currentAnimation == a.ordinal() || (stopWhenDone && a != Action.Default))
      return; // Preserve the current animation

    previousAnimation = currentAnimation;
    currentAnimation = a.ordinal();
    currentFrame = 0;
    count = 0;
    stopWhenDone = stop;
    pauseMovement = stop ? true : false;
  }

  void setDirection(int processingKey) {
    if (processingKey == UP) directionY = -1;
    if (processingKey == DOWN) directionY = 1;
    if (processingKey == LEFT) directionX = -1;
    if (processingKey == RIGHT) directionX = 1;
  }

  void stopMoving() {
    directionX = 0;
    directionY = 0;
  }

  void move() {
    if (pauseMovement) return;
    // Move if our frame is in bounds
    if (x > -95 && directionX == -1) x -= 2;
    if (x < 240 && directionX == 1) x += 2;
    if (y > -55 && directionY == -1) y -= 2;
    if (y < 260 && directionY == 1) y += 2;
  }

  void nextFrame(int interval) {
    count++;
    if (count != interval)
      return;

    int direction = getDirectionIndex();
    int numFrames = animations[currentAnimation][direction].length;

    count = 0;
    currentFrame++;
    if (currentFrame >= numFrames) {
      currentFrame = 0;
      if (stopWhenDone) {
        currentAnimation = previousAnimation;
        stopWhenDone = false;
        pauseMovement = false;
      }
    }
  }

  void animate() {
    int direction = getDirectionIndex();
    image(animations[currentAnimation][direction][currentFrame], x, y);
    nextFrame(5);
  }
}
