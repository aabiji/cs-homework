
class Seaweed {
  float[] offsets;
  int numSegments;

  Seaweed() {
    numSegments = (int)random(5, 8);
    // Create random x offsets for each segment
    offsets = new float[numSegments];
    for (int i = 0; i < numSegments; i++) {
      offsets[i] = random(-10, 10);
    }
  }

  // Draw a bunch of connected, osciallating, curved lines
  void draw(int x) {
    float time = millis() / 500;
    float amplitude = 10; // sine wave amplitude
    float spacing = 0.5; // sine wave spacing
    int h = 50; // segment height
    int y = height - SAND_HEIGHT - numSegments * h;

    beginShape();
    noFill();
    stroke(0, 100, 0);
    strokeWeight(5);

    // Draw the fixed base
    beginShape();
    curveVertex(x, y);
    curveVertex(x, y);

    // Draw the body segments with sway
    for (int i = 0; i < numSegments; i++) {
      // Randomly offset the x position of the vertex
      float xpos = x + offsets[i] + sin(time + i * spacing) * amplitude;
      float ypos = y + (i + 1) * h;
      curveVertex(xpos, ypos);
    }

    // Draw tip with sway
    float offset = sin(time + numSegments * spacing/2) * amplitude;
    curveVertex(x + offsets[numSegments - 1] + offset, y + numSegments * h);
    curveVertex(x + offsets[numSegments - 1] + offset, y + numSegments * h);

    endShape();
    strokeWeight(1);
  }
}

class Background {
  int clock;
  int halfDay; // Max number of ticks in 12 hours (arbitrary of course)
  boolean nightime;
  Seaweed[] forest;

  Background() {
    clock = 0;
    halfDay = 1000;
    nightime = false;
    forest = new Seaweed[40];
    for (int i = 0; i < forest.length; i++) {
      forest[i] = new Seaweed();
    }
  }

  // Cycle between daytime and nightime then notify all pinnipeds
  void cycleDayNight(AnimatedObject[] objs) {
    if (++clock < halfDay) return;
    clock = 0;
    nightime = !nightime;
    for (AnimatedObject obj : objs) {
      if (obj instanceof Pinniped) {
        Pinniped cast = (Pinniped) obj;
        cast.nightime = nightime;
      }
    }
  }

  void drawOcean() {
    int startY = 100;
    int endY = height - SAND_HEIGHT;
    color start = color(132, 188, 243);
    color end = color(6, 29, 149);
    noStroke();

    // Draw a vertical gradient going from light blue to dark blue
    float step = (endY - startY) / 55;
    for (int y = startY; y <= endY; y += step) {
      float t = map(y, startY, endY, 0, 1);
      fill(lerpColor(start, end, t));
      rect(0, y, width, step);
    }
  }

  void drawSky() {
    // Draw the sky. Its color is based on the time of day
    color night = color(8, 39, 102);
    color day = color(172, 229, 238);
    float t = map(clock, 0, halfDay, 0, 1);
    fill(nightime ? lerpColor(night, day, t) : lerpColor(day, night, t));
    rect(0, 0, width, 100);

    // Determine the sun/moon position based on the time of day
    // Just moving the celestial body in a circular motion
    int diameter = 50;
    int time = nightime ? halfDay + clock : clock;
    float angle = map(time, 0, halfDay * 2, 0, 2 * PI);
    PVector center = new PVector(width - 100, 60);
    float x = center.x + cos(angle) * diameter;
    float y = center.y + sin(angle) * diameter;

    // Draw the moon/sun
    fill(nightime ? color(200, 200, 200) : color(255, 255, 51));
    circle(x, y, diameter);
  }

  void draw(AnimatedObject[] objs) {
    cycleDayNight(objs);
    drawSky();
    drawOcean();
    for (int i = 0; i < forest.length; i++) {
      forest[i].draw(20 + i * 20);
    }
  }
}