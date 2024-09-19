
void setup()
{
  size(700, 500);
  strokeWeight(4);
}

void drawSun(int x, int y, int size)
{
  // The sun is yellow
  fill(255, 234, 0);
  stroke(255, 234, 0);
 
  // Draw center circle
  ellipse(x, y, size, size);

  // Draw lines around the circle
  int lines = 12;
  int angle = 0;
  for (int i = 0; i < lines; i++) {
    float radians = angle * PI / 180;
    float startX = x + cos(radians) * (size / 1.5);
    float startY = y + sin(radians) * (size / 1.5);
    float endX = startX + cos(radians) * (size / 4);
    float endY = startY + sin(radians) * (size / 4);
    line(startX, startY, endX, endY);
    angle += (360 / lines);
  }
}

void drawBoat(int x, int y, int hullWidth, int hullHeight)
{
  // Draw the hull in brown
  fill(139, 69, 19);
  stroke(139, 69, 19);
  rect(x, y, hullWidth, hullHeight);
  
  // Draw the spar
  int sparHeight = 300;
  int hullX = x + hullWidth / 2;
  int hullY = y - sparHeight;
  line(hullX, y, hullX, hullY);
  
  // Draw the mast in red
  fill(255, 49, 49);
  stroke(255, 49, 49);
  int mastY = y - 50;
  triangle(hullX, mastY, hullX, hullY, hullX + (hullWidth / 2), mastY);
}

void drawWave(int x, int y, int scale)
{
  // waves are dark blue
  stroke(0, 0, 139);
  
  // Mimick the shape of a wave with a bezier curve
  // The curve has 4 control points (so eight x & y values);
  float[] p = {0, 0, 4.76, -3.5, 5.13, 4.4, 10.06, -1.3};
  for (int i = 0; i < 8; i++) {
    boolean isX = i % 2 == 0;
    p[i] *= scale; // Make the curve larger
    p[i] = isX ? p[i] + x : p[i] + y; // translate the control point
  }

  stroke(0, 0, 0);
  bezier(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]); 
}

void draw()
{
  background(173, 216, 230);
  
  drawSun(70, 70, 50);
  drawBoat(200, 400, 300, 50);
  fill(173, 216, 230); // reset fill to background color
  drawWave(100, 400, 10);

  textSize(20);
  fill(0, 0, 0);
  text("Made by Abigail Adegbiji", 700 - 210, 30);
  textSize(15);
  text("Piet Mondrian would be proud!", 700 - 200, 50);
}
