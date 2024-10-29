// Animation demo
// ---------------
// Abigail Adegbiji
// October 29, 2024
//
// A basic player animation demo.
// Sprites taken from here: https://hormelz.itch.io/8-directional-knight

Character character;

void setup() {
  size(400, 400);

  String[] folders = {"idle", "run", "attack"};
  character = new Character(75, 75, folders);
  character.setAnimation(Action.Default, false);
}

void keyPressed() {
  if (keyCode == UP || keyCode == DOWN ||
      keyCode == LEFT || keyCode == RIGHT) {
    character.setDirection(keyCode);
    character.setAnimation(Action.Run, false);
  }
}

void keyReleased() {
  character.stopMoving();
  character.setAnimation(Action.Default, false);
}

void mousePressed() {
  character.setAnimation(Action.Attack, true); 
}

void draw() {
  background(255);
  character.animate();
  character.move();
}
