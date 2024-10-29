enum Action {
  Attack, Idle, Run
}

class Character {
  int x, y;
  int directionX;
  int directionY;
  int previousKey;

  int count;
  int currentFrame;
  int currentAnimation;

  // Index by action index, direction index then frame index
  PImage[][][] animations;

  Character(int xpos, int ypos, String[] assetFolders) {
    x = xpos;
    y = ypos;
    directionX = 0;
    directionY = 0;
    previousKey = 0;

    count = 0;
    currentFrame = 0;
    currentAnimation = 0;
    loadAnimations(assetFolders);
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

  // TODO: refactor this
  // Get sprite indexes based on the x direction and y direction
  int getDirectionIndex() {
    int[][] indexes = {
      {1, 0, 7}, // Top left, left, bottom left
      {2, 6, 6}, // Top, Bottom, Top
      {3, 4, 5}  // Top right, right, bottom right
    };
    return indexes[directionX + 1][directionY + 1];
  }

  void setAnimation(Action a) {
    currentAnimation = a.ordinal();
    currentFrame = 0;
    count = 0;
  }

  void setDirection(int processingKey) {
    if (processingKey == UP) directionY = -1;
    if (processingKey == DOWN) directionY = 1;
    if (processingKey == LEFT) directionX = -1;
    if (processingKey == RIGHT) directionX = 1;
    if (previousKey != processingKey) {
      setAnimation(Action.Run);
      previousKey = processingKey;
    }
  }

  void stopMoving() {
    directionX = 0;
    directionY = 0;
    previousKey = 0;
  }

  void move() {
    x += directionX;
    y += directionY;
  }

  void animate() {
    int i = getDirectionIndex();
    image(animations[currentAnimation][i][currentFrame], x, y);

    count++;
    if (count == 5) {
      int length = animations[currentAnimation][i].length;
      currentFrame = (currentFrame + 1) % length;
      count = 0;
    }
  }
}
