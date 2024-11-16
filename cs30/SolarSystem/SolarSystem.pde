/*
Solar System Simulation
-----------------------
November 16, 2024
Abigail Adegbiji

A basic simulation of the orbits of the planets in the solar system.
Scroll the mouse wheel to zoom in and out. Hover the mouse over a
planet to show its distance from the sun.
*/

// Data taken from here:
// https://www.princeton.edu/~willman/planetary_systems/Sol/
enum PlanetName {
  Mercury, Venus, Earth, Mars,
  Jupiter, Saturn, Uranus, Neptune
}

color[] planetColors = {
  color(92, 92, 92), color(230, 230, 230),
  color(7, 170, 245), color(153, 61, 0),
  color(176, 127, 53), color(227, 208, 154),
  color(85, 128, 170), color(46, 87, 125)
};

// Semimajor axis in astronomical units
float[] semiMajorAxes = {
  0.3870993, 0.723336, 1.000003,
  1.52371, 5.2029, 9.537,
  19.189, 30.0699
};

// Planet eccentricities
float[] eccentricities = {
  0.20564, 0.00678, 0.01671,
  0.09339, 0.0484, 0.0539,
  0.04726, 0.00859
};

// Orbital periods in years (number of days in 1 earth year)
float[] orbitalPeriods = {
  0.2408467, 0.61519726, 1.0000174,
  1.8808158, 11.862615, 29.447498,
  84.016846, 164.79132
};

// Planet diameters in kilometers, taken
// from here: https://www.jpl.nasa.gov/_edu/pdfs/scaless_reference.pdf
int[] diameters = {
  4879, 12104, 12756,
  6792, 142984, 120536,
  51118, 49528
};

class Planet {    
  PlanetName name;
  int diameter;
  float semiMajorAxis;
  color planetColor;
  float eccentricity;
  float orbitalPeriod;
  float perihelionAngle;
  int counter;
  ArrayList<PVector> previousPoints;

  Planet(PlanetName p) {
    name = p;
    perihelionAngle = 0;
    counter = 0;
    previousPoints = new ArrayList<PVector>();
    int i = p.ordinal();
    diameter = diameters[i];
    planetColor = planetColors[i];
    semiMajorAxis = semiMajorAxes[i];
    eccentricity = eccentricities[i];
    orbitalPeriod = orbitalPeriods[i];
  }

  float getDistanceFromSun() {
    float theta = radians(perihelionAngle);
    float axis = semiMajorAxis * 1495978707; // Convert from AU to km
    return axis * (1 - eccentricity * eccentricity) / (1 + eccentricity * cos(theta));
  }

  // Move a planet around its orbit by one day
  void move() {
    float numEarthDays = orbitalPeriod * 365.25;
    perihelionAngle += 1 * 360 / numEarthDays;
  }

  // Draw planetary info
  int debug(int yOffset) {
    String[] info = {
      String.format("%s", name.toString()),
      String.format("Diameter: %d km", diameter),
      String.format("Eccentricity: %1.4e", eccentricity),
      String.format("Semi major axis: %1.4e AU", semiMajorAxis),
      String.format("Orbital period: %1.4e earth years", orbitalPeriod),
      String.format("Angle around perihelion %1.4e°", perihelionAngle),
      String.format("Distance from Sun: %1.4e km", getDistanceFromSun())
    };

    int size = 13;
    textSize(size);
    for (int i = 0; i < info.length; i++) {
      fill(planetColor);
      text(info[i], 0, yOffset + (i + 1) * size); 
    }

    return size * info.length; // Return the total height
  }

  PVector calculatePosition(int distanceScale) {
    float distance = getDistanceFromSun() / distanceScale;
    float theta = radians(perihelionAngle);
    return new PVector(cos(theta) * distance, sin(theta) * distance);
  }

  PVector scalePosition(PVector p, float zoom) {
    PVector scaled = new PVector();
    scaled.x = width / 2 + p.x * zoom;
    scaled.y = height / 2 + p.y * zoom;
    return scaled;
  }

  // Save the previous position every so often
  void savePosition(PVector p) {
    counter++;
    int cap = name == PlanetName.Mercury ? 3 : 5;
    if (counter < cap) return;

    counter = 0;
    previousPoints.add(p);

    boolean innerPlanet = name.ordinal() < PlanetName.Jupiter.ordinal();
    int maxSize = (name.ordinal() + 1) * (innerPlanet ? 10 : 100);
    if (previousPoints.size() == maxSize)
      previousPoints.remove(0);
  }

  void renderHoverInfo(float x, float y, int planetRadius) {
    String str = String.format("%1.4e km from sun", getDistanceFromSun());
    boolean inCircle = dist(x, y, mouseX, mouseY) < planetRadius;
    if (!inCircle) return;

    textSize(15);
    int w = (int)textWidth(str);
    text(str, x - w / 2, y - planetRadius / 2);
  }

  // Draw a fading orbit trail
  void renderTrail(float zoom) {
    strokeWeight(2);

    int size = previousPoints.size();
    if (size == 0) return; // Avoid division by zero error

    // The trails of the inner plaents will fade every point
    // but the trails of the outer planets will fade every
    // 'interval' points
    float step = size > 255 ? 1 : 255 / size;
    int interval = size > 255 ? round(size / 255) : 1;
    float transparency = 0;

    for (int i = 0; i < size; i++) {
      PVector point = previousPoints.get(i);
      PVector previous = i > 0 ? previousPoints.get(i - 1) : point;

      point = scalePosition(point, zoom);
      previous = scalePosition(previous, zoom);

      if (i % interval == 0) transparency += step;
      stroke(70, 70, 70, transparency);
      line(point.x, point.y, previous.x, previous.y);
    }
  }

  void render(int distanceScale, int diameterScale, float zoom) {
    float size = diameter / diameterScale * zoom;

    // By calculating the actual xy coordinate and the scaled xy
    // coordinate separately, we can zoom in and out more smoothly
    PVector position = calculatePosition(distanceScale);
    PVector scaled = scalePosition(position, zoom);

    savePosition(position);
    renderTrail(zoom);

    if (scaled.x > width || scaled.y > height) return;
    fill(planetColor);
    circle(scaled.x, scaled.y, size);
    renderHoverInfo(scaled.x, scaled.y, (int)size);
  }
}

Planet[] planets;
float zoomLevel;

void setup() {
  // Load each planet
  PlanetName[] names = PlanetName.values();
  planets = new Planet[names.length];
  for (int i = 0; i < names.length; i++) {
    planets[i] = new Planet(names[i]);
  }
  zoomLevel = 1;
  size(1000, 850);
}

void mouseWheel(MouseEvent event) {
  float direction = event.getCount();
  if (direction == -1)
    zoomLevel = max(0.05, zoomLevel - 0.02);
  if (direction == 1)
    zoomLevel = min(1.50, zoomLevel + 0.02);
}

void renderSystem() {
  // Render the sun
  fill(255, 255, 0);
  float diameter = 1391400 / 10000;
  circle(width / 2, height / 2, diameter * zoomLevel);
 
  // Render the planets
  for (int i = 0; i < planets.length; i++) {
    planets[i].render(6400000, 900, zoomLevel);
  }

  // Render the planet info
  int textY = 0;
  for (int i = 0; i < planets.length; i++) {
    textY += planets[i].debug(textY) + 15;
  }
}

void draw() {
  background(0);
  renderSystem();
  for (int i = 0; i < planets.length; i++) {
    planets[i].move();
  }
}
