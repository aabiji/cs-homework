import java.util.ArrayList;
import java.util.Iterator;

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

  Particle(PVector xy, PVector acc, color _color) {
    position = xy.copy();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    transparency = (int)random(128, 255);
    c = _color;
    acceleration = acc;
  }

  boolean dead() {
    return transparency < 0;
  }

  void update(int updateCount) {
    velocity.add(acceleration);
    position.add(velocity);

    // Bounce off the window borders
    float friction = 0.1;
    if (position.y > height || position.y < 0) {
      velocity.y -= friction;
      velocity.y *= -1;
    }
    if (position.x > width || position.x < 0) {
      velocity.x -= friction;
      velocity.x *= -1;
    }

    // Lose a life every 5 updates
    if (updateCount ==  5)
      transparency = max(transparency - 1, -1);
  }

  void render(int shape, float rotation) {
    if (dead()) return;
    pushMatrix();

    translate(position.x, position.y);
    rotate(rotation);
    noStroke();
    fill(c, transparency);

    // Cycle through drawing circle, rectangle, hexagon and triangle
    int size = shape == 0 ? transparency / 20 : transparency / 25;
    if (shape == 0) ellipse(0, 0, size, size);
    if (shape == 1) drawShape(0, 0, size, 4);
    if (shape == 2) drawShape(0, 0, size, 6);
    if (shape == 3) drawShape(0, 0, size, 3);

    popMatrix();
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector baseAcceleration;
  color baseColor;
  PVector position;
  boolean addParticle;
  int updateCount;

  ParticleSystem(int x, int y) {
    particles = new ArrayList<Particle>();
    baseAcceleration = new PVector(0, 0);
    position = new PVector(x, y);
    baseColor = colorFromCursor();
    updateCount = 0;

    addParticle = true;
    particles.add(new Particle(position, baseAcceleration, baseColor));
  }

  void updatePosition(int x, int y) {
    position.x = x;
    position.y = y;
    baseColor = colorFromCursor();
  }

  void update(int currentShape, float rotation) {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update(updateCount);

      if (p.dead()) particles.remove(i);
      else p.render(currentShape, rotation);
    }

    // Only spawn particles every 5 frames
    updateCount++;
    if (addParticle && updateCount == 5) {
      particles.add(new Particle(position, baseAcceleration, baseColor));
      updateCount = 0;
    }
  }
}

class Simulation {
  int currentShape;
  PVector acceleration;
  int particleRotation;
  ArrayList<ParticleSystem> systems;

  Simulation() {
    systems = new ArrayList<ParticleSystem>();
    currentShape = 0;
    particleRotation = 0;
    setGravity(0, 1);
    // Initial particles should be invisible
    addParticleSystem(width*2, height*2);
  }

  void addParticleSystem(int x, int y) {
    ParticleSystem system = new ParticleSystem(x, y);
    system.baseAcceleration = acceleration;
    systems.add(system);
  }

  void cycleShape() {
    currentShape = (currentShape + 1) % 4;
  }

  void setParticleRotation(float direction) {
    particleRotation += direction * 5;
    particleRotation = max(0, min(particleRotation, 360));
  }

  void setGravity(int directionX, int directionY) {
    // Change the acceleration for new and existing particles
    if (acceleration == null) acceleration = new PVector();    
    acceleration.x = 0.03 * directionX;
    acceleration.y = 0.03 * directionY;

    for (ParticleSystem system : systems) {
      system.baseAcceleration = acceleration;
      for (Particle particle : system.particles) {
        particle.acceleration = acceleration;
      }
    }
  }

  void randomizeParticles() {
    // Make existing particles move in random directions
    Iterator<ParticleSystem> systemIterator = systems.iterator();
    while (systemIterator.hasNext()) {
      Iterator<Particle> it = systemIterator.next().particles.iterator();
      while (it.hasNext()) {
        Particle p = it.next();
        float x = random(-1, 1);
        float y = random(-1, 1);
        float a = random(0.01, 0.03);
        p.velocity = new PVector(x, y);
        p.acceleration = new PVector(a * x, a * y);
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

      system.update(currentShape, radians(particleRotation));
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
  if (keyCode == RIGHT) simulation.setGravity(1, 0);
  if (keyCode == LEFT) simulation.setGravity(-1, 0);
  if (key == 'r' || key == 'R')
    simulation.stopParticleSystems();
}

void mouseWheel(MouseEvent event) {
  // Change the particle rotation using the scroll wheel
  float direction = event.getCount();
  simulation.setParticleRotation(direction);
}  

void mouseClicked() {
  if (mouseButton == LEFT)   simulation.addParticleSystem(mouseX, mouseY);
  if (mouseButton == RIGHT)  simulation.cycleShape();
  if (mouseButton == CENTER) simulation.randomizeParticles();
}

void draw() {
  background(255);
  simulation.update();
}
