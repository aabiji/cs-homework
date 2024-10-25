
void setup() {
  size(400, 400);
}

class BoundingBox {
  PVector[] edges;
  PVector[] vertices;
  int x, y, w, h, rotation;

  BoundingBox(int width, int height) {
    w = width;
    h = height;
    x = y = rotation = 0;
    edges = new PVector[4];
    vertices = new PVector[4];
  }

  // Calculate the vertices of our rectangle, accounting for rotation
  void calculateVertices() {
    // Vertex positions if the center was (0, 0)
    // top left, top right, bottom left, bottom right
    float[][] localPosition = {{-w/2, -h/2}, {w/2, -h/2}, {-w/2, h/2}, {w/2, h/2}};
    float theta = radians(rotation);
    int centerX = x + w/2;
    int centerY = y + h/2;
    for (int i = 0; i < 4; i++) {
      float[] point = localPosition[i];
      float rotatedX = point[0] * cos(theta) - point[1] * sin(theta);
      float rotatedY = point[0] * sin(theta) + point[1] * cos(theta);
      vertices[i] = new PVector(rotatedX + centerX, rotatedY + centerY);
    }
  }

  // Calculate the top, bottom, right and left edge (in that order)
  void calculateEdges() {
    edges[0] = new PVector(vertices[1].x - vertices[0].x, vertices[1].y - vertices[0].y);
    edges[1] = new PVector(vertices[3].x - vertices[2].x, vertices[3].y - vertices[2].y);
    edges[2] = new PVector(vertices[3].x - vertices[1].x, vertices[3].y - vertices[1].y);
    edges[3] = new PVector(vertices[2].x - vertices[0].x, vertices[2].y - vertices[0].y);
  }
}

// Use the separating axis theorem to check if the 2 rectangles are colliding.
// The idea behind SAT is that if two convex polygons are not colliding, there's
// at least one line (axis) on which you can project both shapes, and their
// projections will not overlap. If you can find that line,
// the shapes are guaranteed not to collide.
// Ressources:
// https://stackoverflow.com/questions/62028169/how-to-detect-when-rotated-rectangles-are-colliding-each-other
// https://www.youtube.com/watch?v=Nm1Cgmbg5SQ
boolean didCollide(BoundingBox a, BoundingBox b) {
  a.calculateVertices();
  a.calculateEdges();
  b.calculateVertices();
  b.calculateEdges();

  // Get vectors that are perpendicular for each rectangle edge
  // They will be our axes
  PVector[] axes = new PVector[8];
  for (int i = 0; i < 4; i++) {
    axes[i] = new PVector(a.edges[i].y, -a.edges[i].x);
    axes[i+4] = new PVector(b.edges[i].y, -b.edges[i].x);
  }

  for (int i = 0; i < 8; i++) {
    // Minimum and maximum dot product for both rectangles
    double a_min = Double.MAX_VALUE;
    double a_max = Double.MIN_VALUE;
    double b_min = Double.MAX_VALUE;
    double b_max = Double.MIN_VALUE;

    // Find the minimum and maximum vertex projections for both rectangles
    // To project the vertex unto the axis we'll use the dot product
    for (int j = 0; j < 4; j++) {
      double dot = a.vertices[j].dot(axes[i]);
      if (dot < a_min) a_min = dot;
      if (dot > a_max) a_max = dot;

      dot = b.vertices[j].dot(axes[i]);
      if (dot < b_min) b_min = dot;
      if (dot > b_max) b_max = dot;
    }

    // Check if the left edge of the second rectangle overlaps with the
    // right edge of the first rectangle and that the first rectangle comes
    // before the second rectangle. Same idea for the second rectangle.
    boolean noGap = (b_min < a_max && b_min > a_min) || (a_min < b_max && a_min > b_min);
    if (!noGap) return false; // Found a separating axis.
  }
  return true;
}

BoundingBox boxA = new BoundingBox(25, 25);
BoundingBox boxB = new BoundingBox(50, 100);

void render(int x, int y, int w, int h, int rotation, color c) {
  pushMatrix();
  translate(x + w / 2, y + h / 2);
  rotate(radians(rotation));
  fill(c);
  rect(-w/2, -h/2, w, h);
  popMatrix();
}

void draw() {
  background(255);

  if (keyPressed)
    boxA.rotation = (boxA.rotation + 1) % 360;
  boxA.x = mouseX;
  boxA.y = mouseY;
  boxB.x = 150;
  boxB.y = 300;

  color c = didCollide(boxA, boxB) ? color(255, 0, 0) : color(255, 255, 255);
  render(mouseX, mouseY, 25, 25, boxA.rotation, c);
  render(150, 300, 50, 100, boxB.rotation, color(0, 0, 255));
}