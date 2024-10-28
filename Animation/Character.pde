import java.util.EnumSet;

enum AnimationType {
 Idle, Movement, Attack
}

enum Direction {
  Up, Down, Left, Right
}

class Character {
  int x, y;
  // TODO: explain why i'm using this
  EnumSet<Direction> directions;

  int currentFrame;
  int animationCount;
  int animationIndex;
  PImage[] frames;

  Character(String sheetPath, String infoPath) {
    x = 0;
    y = 0;
    directions = EnumSet.noneOf(Direction.class);

    currentFrame = 0;
    animationCount = 0;
    animationIndex = 0;
    loadSpriteSheet(sheetPath, infoPath);
  }

  void loadSpriteSheet(String imgPath, String jsonPath) {
    PImage spritesheet = loadImage(imgPath);

    JSONObject json = loadJSONObject(jsonPath);
    JSONArray framesObj = json.getJSONArray("frames");

    int numFrames = framesObj.size();
    frames = new PImage[numFrames];

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
  }

  void setDirection(Direction d) {
    directions.add(d);
    // Remove opposing directions
    if (d == Direction.Up) directions.remove(Direction.Down);
    if (d == Direction.Down) directions.remove(Direction.Up);
    if (d == Direction.Left) directions.remove(Direction.Right);
    if (d == Direction.Right) directions.remove(Direction.Left);
  }

  void stopMoving() {
    directions.clear();
  }
  
  void move() {
    if (directions.contains(Direction.Up)) y -= 1;
    if (directions.contains(Direction.Down)) y += 1;
    if (directions.contains(Direction.Right)) x += 1;
    if (directions.contains(Direction.Left)) x -= 1;
  }

  void animate() {
    image(frames[currentFrame], x, y);

    animationCount++;
    if (animationCount == 5) { // TODO: shouldn't we be getting this from json???
      animationCount = 0;
      currentFrame++;
      if (currentFrame >= frames.length)
        currentFrame = 0;
    }
  }
}
