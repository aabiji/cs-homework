/*
Particle system requirements:
- Particle simulation
  - Bounce off borders (with reduced velocity to account for friction)
  - Send existing particles flying in random directions when the center mouse is clicked
    - Using Iterator
  - Zoom in and out of simulation
*/

// Compute a color based on the cursor xy coordinates
color colorFromCursor() {
  float r = map(mouseX, 0, width, 0, 255);
  float g = map(mouseX * mouseY, 0, width * height, 0, 255);
  float b = map(mouseY, 0, height, 0, 255);
  return color(r, g, b);
}

// Manually draw any shape
void drawShape(int x, int y, int size, int numSides) {
  float step = 360 / numSides;
  beginShape();
  for (float i = 0; i < 360; i += step) {
    float angle = radians(i);
    float pointX = x + cos(angle) * size;
    float pointY = y + sin(angle) * size;
    vertex(pointX, pointY);
  }
  endShape(CLOSE);
}

class Particle {
  PVector velocity;
  PVector position;
  int transparency;
  color c;

  Particle(PVector xy, color _color) {
    position = xy.copy();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    transparency = (int)random(128, 255);
    c = _color; 
  }

  boolean dead() {
    return transparency < 0;
  }

  void update(PVector acceleration) {
    velocity.add(acceleration);
    position.add(velocity);
    transparency = max(transparency - 1, -1);
  }

  void render(int shape) {
    if (dead()) return;
    pushMatrix();

    translate(position.x, position.y);
    noStroke();
    fill(c, transparency);

    // Cycle through drawing rectangle, circle, hexagon and triangle
    if (shape == 0) drawShape(0, 0, 8, 4);
    if (shape == 1) ellipse(0, 0, 10, 10);
    if (shape == 2) drawShape(0, 0, 7, 6);
    if (shape == 3) drawShape(0, 0, 8, 3);

    popMatrix();
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector position;
  color baseColor;

  ParticleSystem(int x, int y) {
    particles = new ArrayList<Particle>();
    position = new PVector(x, y);
    baseColor = colorFromCursor();
  }

  void updatePosition(int x, int y) {
    position.x = x;
    position.y = y;
    baseColor = colorFromCursor();
  }

  void update(PVector acceleration, int currentShape, boolean addShape) {
    if (addShape)
      particles.add(new Particle(position, baseColor));

    for (int i = particles.size() - 1; i > 0; i--) {
      Particle p = particles.get(i);
      p.update(acceleration);

      if (p.dead()) particles.remove(i);
      else p.render(currentShape);
    }
  }
}

class Simulation {
  ArrayList<ParticleSystem> systems;
  int currentShape;
  PVector acceleration;
  boolean dieOff;

  Simulation() {
    systems = new ArrayList<ParticleSystem>();
    systems.add(new ParticleSystem(0, 0));
    acceleration = new PVector();
    setGravity(0, 1);
    currentShape = 0;
    dieOff = false;
  }

  void addParticleSystem() {
    systems.add(new ParticleSystem(mouseX, mouseY));
  }

  void cycleShape() {
    currentShape = (currentShape + 1) % 4;
  }

  void setGravity(int directionX, int directionY) {
    acceleration.x = 0.02 * directionX;
    acceleration.y = 0.02 * directionY;
  }

  void update() {
    for (int i = 0; i < systems.size(); i++) {
      ParticleSystem system = systems.get(i);
      if (i == 0) // The first particle system is the one that follows the mouse
        system.updatePosition(mouseX, mouseY);
      system.update(acceleration, currentShape, !dieOff);
    }
  }
}

Simulation simulation;

void setup() {
  size(600, 600, P2D);
  simulation = new Simulation();
}

void keyReleased() {
  if (keyCode == UP) simulation.setGravity(0, -1);
  if (keyCode == DOWN) simulation.setGravity(0, 1);
  if (keyCode == LEFT) simulation.setGravity(-1, 0);
  if (keyCode == RIGHT) simulation.setGravity(1, 0);
  if (key == 'r' || key == 'R') simulation.dieOff = true;
}

void mouseClicked() {
  if (mouseButton == LEFT)
    simulation.addParticleSystem();
  if (mouseButton == RIGHT)
    simulation.cycleShape();
}

void draw() {
  background(255);
  simulation.update();
}
