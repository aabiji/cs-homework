// Animations taken from here:
// https://hormelz.itch.io/8-directional-knight

Character character;

void setup() {
  size(400, 400);
  character = new Character("Knight_Idle_dir8.png", "Knight_Idle_dir8.json");
}

void keyPressed() {
  if (keyCode == UP) character.setDirection(Direction.Up);
  if (keyCode == DOWN) character.setDirection(Direction.Down);
  if (keyCode == LEFT) character.setDirection(Direction.Left);
  if (keyCode == RIGHT) character.setDirection(Direction.Right);
}

void keyReleased() {
  character.stopMoving();
}

void draw() {
  background(255);
  character.animate();
  character.move();
}
