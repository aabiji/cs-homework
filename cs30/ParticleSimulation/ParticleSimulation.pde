/*
Particle system requirements:
- Particle simulation
  - Bounce off borders (with reduced velocity to account for friction)
  - Right click to cycle through 4 possible particle shapes
  - Particle system that stays at the location the mouse clicked
  - Send existing particles flying in random directions when the center mouse is clicked
    - Using Iterator
  - All particle systems die off when r or R is pressed
  - Use arrow keys to change the direction of gravity
  - Zoom in and out of simulation
*/

class Particle {
  PVector acceleration;
  PVector velocity;
  PVector position;

  int transparency;
  color c;

  Particle(PVector xy) {
    position = xy.copy();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0.02);

    transparency = (int)random(128, 255);
    c = determineColor();
  }

  // Compute a color based on the mouse xy coordinates
  color determineColor() {
     float r = map(mouseX, 0, width, 0, 255);
     float g = map(mouseX * mouseY, 0, width * height, 0, 255);
     float b = map(mouseY, 0, height, 0, 255);
     return color(r, g, b);
  }

  boolean dead() {
    return transparency < 0;
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    transparency = max(transparency - 1, -1);
  }

  void render() {
    if (dead()) return;
    pushMatrix();
    translate(position.x, position.y);
    noStroke();
    fill(c, transparency);
    ellipse(0, 0, 15, 15);
    popMatrix();
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector position;

  ParticleSystem(int x, int y) {
    particles = new ArrayList<Particle>();
    position = new PVector(x, y);
  }

  void setPosition(int x, int y) {
    position.x = x;
    position.y = y;
  }

  void update() {
    particles.add(new Particle(position));

    for (int i = particles.size() - 1; i > 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.dead()) {
        particles.remove(i);
      } else {
        p.render();
      }
    }
  }
}

ArrayList<ParticleSystem> systems;

void setup() {
  size(600, 600, P2D);
  systems = new ArrayList<ParticleSystem>();
  systems.add(new ParticleSystem(0, 0));
}

void mouseClicked() {
  systems.add(new ParticleSystem(mouseX, mouseY));
}

void draw() {
  background(255);
  for (int i = 0; i < systems.size(); i++) {
    ParticleSystem s = systems.get(i);
    // The first particle system follows the mouse
    if (i == 0) s.setPosition(mouseX, mouseY);
    s.update();
  }
}
