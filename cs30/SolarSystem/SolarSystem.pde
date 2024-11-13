
// data taken from here: https://www.princeton.edu/~willman/planetary_systems/Sol/
enum PlanetName { Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune }

color[] planetColors = {
  color(92, 92, 92), color(230, 230, 230), color(7, 170, 245),
  color(153, 61, 0), color(176, 127, 53), color(227, 208, 154),
  color(85, 128, 170), color(46, 87, 125)
};

// semimajor axis in astronomical units
float[] semiMajorAxes = { 0.3870993, 0.723336, 1.000003, 1.52371, 5.2029, 9.537, 19.189, 30.0699 };

// planet eccentricities
float[] eccentricities = { 0.20564, 0.00678, 0.01671, 0.09339, 0.0484, 0.0539, 0.04726, 0.00859 };

// orbital periods in years (number of days in 1 earth year)
float[] orbitalPeriods = { 0.2408467, 0.61519726, 1.0000174, 1.8808158, 11.862615, 29.447498, 84.016846, 164.79132 };

// planet diameters in kilometers, taken from here: https://www.jpl.nasa.gov/_edu/pdfs/scaless_reference.pdf
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

  void render(int scale) {
    float size = diameter / scale;
    fill(planetColors[name.ordinal()]);
    ellipse(300, 300, size, size);
  }
}

Planet[] planets;

void renderTheSun(int scale) {
  float scaledDiameter = 1391400 / scale;
  fill(255, 255, 0);
  ellipse(width/2, height/2, scaledDiameter, scaledDiameter);
}

void setup() {
  // Load each planet
  PlanetName[] names = PlanetName.values();
  planets = new Planet[names.length];
  for (int i = 0; i < names.length; i++) {
    planets[i] = new Planet(names[i]);
  }

  size(600, 600);
}

void draw() {
  background(0);
  renderTheSun(10000);
}
