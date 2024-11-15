/*
Solar System Simulation
-----------------------
November 15, 2024
Abigail Adegbiji

A basic simulation of the orbits of the planets in the solar system.
Use the mouse wheel to zoom in and out.
*/

color[] planetColors = {
  color(92, 92, 92), color(230, 230, 230), color(7, 170, 245),
  color(153, 61, 0), color(176, 127, 53), color(227, 208, 154),
  color(85, 128, 170), color(46, 87, 125)
};

// Data taken from here: https://www.princeton.edu/~willman/planetary_systems/Sol/
enum PlanetName { Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune }

// Semimajor axis in astronomical units
float[] semiMajorAxes = { 0.3870993, 0.723336, 1.000003, 1.52371, 5.2029, 9.537, 19.189, 30.0699 };

// Planet eccentricities
float[] eccentricities = { 0.20564, 0.00678, 0.01671, 0.09339, 0.0484, 0.0539, 0.04726, 0.00859 };

// Orbital periods in years (number of days in 1 earth year)
float[] orbitalPeriods = { 0.2408467, 0.61519726, 1.0000174, 1.8808158, 11.862615, 29.447498, 84.016846, 164.79132 };

// Planet diameters in kilometers, taken from here: https://www.jpl.nasa.gov/_edu/pdfs/scaless_reference.pdf
int[] diameters = { 4879, 12104, 12756, 6792, 142984, 120536, 51118, 49528 };

class Planet {    
  PlanetName name;
  int diameter;
  float semiMajorAxis;
  float eccentricity;
  float orbitalPeriod;
  float perihelionAngle;

  Planet(PlanetName p) {
    name = p;
    perihelionAngle = 0;
    int i = p.ordinal();
    semiMajorAxis = semiMajorAxes[i];
    eccentricity = eccentricities[i];
    orbitalPeriod = orbitalPeriods[i];
    diameter = diameters[i];
    move();
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
      fill(planetColors[name.ordinal()]);
      text(info[i], 0, yOffset + (i + 1) * size); 
    }

    return size * info.length; // Return the total height
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

  void render(PGraphics orbitTrails, int distanceScale, int diameterScale) {
    // Draw the planet
    float theta = radians(perihelionAngle);
    float distance = getDistanceFromSun() / distanceScale;
    float x = cos(theta) * distance;
    float y = sin(theta) * distance;
    float size = diameter / diameterScale;
    fill(planetColors[name.ordinal()]);
    ellipse(x, y, size, size);

    // Draw the orbit trail
    float realX = orbitTrails.width/2 + x;
    float realY = orbitTrails.height/2 + y;
    int radius = name.ordinal() < PlanetName.Jupiter.ordinal() ? 2 : 25;
    noStroke();
    fill(color(128, 128, 128, 50));
    orbitTrails.circle(realX, realY, radius);
  }
}

Planet[] planets;
float zoomLevel;
PGraphics orbitTrails;

void setup() {
  // Load each planet
  PlanetName[] names = PlanetName.values();
  planets = new Planet[names.length];
  for (int i = 0; i < names.length; i++) {
    planets[i] = new Planet(names[i]);
    for (int j = 0; j < 365; j++) {
      planets[i].move();
    }
  }

  zoomLevel = 1;
  size(1000, 850);
  orbitTrails = createGraphics(14000, 14000);
}

void mouseWheel(MouseEvent event) {
  float direction = event.getCount();
  if (direction == -1)
    zoomLevel = max(0.05, zoomLevel - 0.05);
  if (direction == 1)
    zoomLevel = min(1.25, zoomLevel + 0.05);
}

void renderSystem() {
  pushMatrix();
  translate(width/2, height/2);
  scale(zoomLevel);

  // TODO: how to scale the mouse position based on the zoom level?
  int centerX = orbitTrails.width/2;
  int centerY = orbitTrails.height/2;
  image(orbitTrails, -centerX, -centerY);

  // Render the sun
  float scaledDiameter = 1391400 / 10000;
  fill(255, 255, 0);
  ellipse(0, 0, scaledDiameter, scaledDiameter);
  
  // Render the planets
  orbitTrails.beginDraw();
  for (int i = 0; i < planets.length; i++) {
    planets[i].render(orbitTrails, 6400000, 900);
  }
  orbitTrails.endDraw();

  popMatrix();
}

void draw() {
  background(0);
  renderSystem();
  // Step the simulation
  int offset = 0;
  for (int i = 0; i < planets.length; i++) {
    planets[i].move();
    int totalHeight = planets[i].debug(offset);
    offset += totalHeight + 15;
  }
}
