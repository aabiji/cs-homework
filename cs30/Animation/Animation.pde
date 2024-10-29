// Animations taken from here:
// https://hormelz.itch.io/8-directional-knight

Character character;

void setup() {
  size(400, 400);

  String[] folders = {"attack", "idle", "run"};
  character = new Character(75, 75, folders);
  character.setAnimation(Action.Idle);
}

void keyPressed() {
  if (keyCode == UP || keyCode == DOWN ||
      keyCode == LEFT || keyCode == RIGHT)
    character.setDirection(keyCode);
}

void keyReleased() {
  character.stopMoving();
  character.setAnimation(Action.Idle);
}

void draw() {
  background(255);
  character.animate();
  character.move();
}
