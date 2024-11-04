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
  PVector acceleration;
  PVector position;
  int transparency;
  color c;
  int updateCount;

  Particle(PVector xy, PVector acc, color _color) {
    position = xy.copy();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    transparency = (int)random(128, 255);
    c = _color;
    acceleration = acc;
    updateCount = 0;
  }

  boolean dead() {
    return transparency < 0;
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);

    // Bounce off the window borders
    // TODO: reduce speed when bouncing off and clamp the number of particles
    if (position.y > height || position.y < 0) {
      velocity.y *= -1;
    }
    if (position.x > width || position.x < 0) {
      velocity.x *= -1;
    }

    // Lose a life every 5 updates
    updateCount++;
    if (updateCount % 5 == 0) {
      transparency = max(transparency - 1, -1);
      updateCount = 0;
    }
  }

  void render(int shape) {
    if (dead()) return;
    pushMatrix();

    translate(position.x, position.y);
    noStroke();
    fill(c, transparency);

    // Cycle through drawing circle, rectangle, hexagon and triangle
    if (shape == 0) ellipse(0, 0, 10, 10);
    if (shape == 1) drawShape(0, 0, 8, 4);
    if (shape == 2) drawShape(0, 0, 7, 6);
    if (shape == 3) drawShape(0, 0, 8, 3);

    popMatrix();
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector baseAcceleration;
  color baseColor;
  PVector position;
  boolean addParticle;

  ParticleSystem(int x, int y) {
    particles = new ArrayList<Particle>();
    baseAcceleration = new PVector(0, 0);
    position = new PVector(x, y);
    baseColor = colorFromCursor();

    addParticle = true;
    particles.add(new Particle(position, baseAcceleration, baseColor));
  }

  void updatePosition(int x, int y) {
    position.x = x;
    position.y = y;
    baseColor = colorFromCursor();
  }

  void update(int currentShape) {
    if (addParticle)
      particles.add(new Particle(position, baseAcceleration, baseColor));

    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();

      if (p.dead()) particles.remove(i);
      else p.render(currentShape);
    }
  }
}

class Simulation {
  int currentShape;
  PVector acceleration;
  ArrayList<ParticleSystem> systems;

  Simulation() {
    systems = new ArrayList<ParticleSystem>();
    setGravity(0, 1);
    addParticleSystem();
    currentShape = 0;
  }

  void addParticleSystem() {
    ParticleSystem system = new ParticleSystem(mouseX, mouseY);
    system.baseAcceleration = acceleration;
    systems.add(system);
  }

  void cycleShape() {
    currentShape = (currentShape + 1) % 4;
  }

  void setGravity(int directionX, int directionY) {
    // Change the acceleration for new and existing particles
    if (acceleration == null) acceleration = new PVector();    
    acceleration.x = 0.02 * directionX;
    acceleration.y = 0.02 * directionY;

    for (ParticleSystem system : systems) {
      system.baseAcceleration = acceleration;
      for (Particle particle : system.particles) {
        particle.acceleration = acceleration;
      }
    }
  }
  
  void stopParticleSystems() {
    // All systems except the one that follows the mouse should stop
    for (int i = 1; i < systems.size(); i++) {
      systems.get(i).addParticle = false;
    }
  }

  void update() {
    for (int i = systems.size() - 1; i >= 0; i--) {
      ParticleSystem system = systems.get(i);

      if (system.particles.size() == 0) {
        systems.remove(i); // Remove dead particle system
      }

      if (i == 0) {
        // The first particle system is the one that follows the mouse
        system.updatePosition(mouseX, mouseY);
      }

      system.update(currentShape);
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
  if (key == 'r' || key == 'R') simulation.stopParticleSystems();
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
