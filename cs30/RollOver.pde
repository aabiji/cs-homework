/*
Tile draw
---------
Abigail Adegbiji - October 4, 2024
A drawing program that uses a rollover as a color palette.
Press down and move the mouse to draw.

Clicking the top left square  makes all the squares turn on
until the mouse moves outside of the square.
Clicking the bottom right square makes all the squares
fade from white to their respective colors. Clicking on
any of the squares changes the drawing color.

Right clicking on any of the tiles servse as an eraser,
changing the draw color to transparent.
*/

// Red, green, blue, yellow
color baseColors[] = {color(224, 108, 118), color(152, 195, 121), color(97, 175, 239), color(229, 192, 123)};
color squareColors[] = {baseColors[0], baseColors[1], baseColors[2], baseColors[3]};

int squareSize = 50;
int currentColor = color(0, 0, 0, 0);

boolean reverseFade = false;
boolean topLeftHovered = false;
boolean hoverStates[]; // Mouse hover states for the 4 quadrants

PGraphics canvas;

void setup() {
  size(600, 600);
  canvas = createGraphics(600, 600);
}

// Get different shades of a color by controlling its transparency
color getShade(color c, boolean up) {
  float direction = up ? -1 : 1;
  float t = alpha(c) - direction * 5;
  t = min(max(t, 0), 255);
  return color(red(c), green(c), blue(c), t);
}

void mousePressed() {
  // Check if the top left square is clicked
  if (hoverStates[0])
    topLeftHovered = true;

  // Check if the bottom right square is clicked
  if (hoverStates[3]) {
    reverseFade = true;
    // Make each square transparent
    for (int i = 0; i < 4; i++) {
      color c = baseColors[i];
      squareColors[i] = color(red(c), green(c), blue(c), 0); 
    }
  }

  // Change the current color by clicking on a qudrant
  for (int i = 0; i < 4; i++) {
    if (hoverStates[i] && mouseButton == LEFT) {
      currentColor = baseColors[i];
      break;
    } else if (hoverStates[i] && mouseButton == RIGHT) {
      currentColor = color(0, 0, 0, 0); // TODO: fixme
      break;
    }
  }
}

void drawSquares() {
  if (topLeftHovered && !hoverStates[0])
    topLeftHovered = false;

  // Mouse hover states in the 4 quadrants
  boolean left = mouseX <= squareSize;
  boolean right = mouseX >= squareSize && mouseX <= squareSize * 2;
  boolean top = mouseY <= squareSize;
  boolean bottom = mouseY >= squareSize && mouseY <= squareSize * 2;
  hoverStates = new boolean[]{left && top, right && top, left && bottom, right && bottom};

  for (int i = 0; i < 4; i++) {
    // The square should turn on when hovered on. However the bottom right square
    // should also fade when clicked
    if (hoverStates[i] && !(reverseFade && hoverStates[3])) {
      squareColors[i] = baseColors[i];
    }

    // When the bottom right is clicked all squares should fade from the white to their base color
    else if (reverseFade) {
      squareColors[i] = getShade(squareColors[i], true);
      if (squareColors[i] == baseColors[i])
        reverseFade = false;
    }

    // If the top left square was clicked and the mouse is still on the top left square
    // all tiles should turn on. Else, the square color should fade.
    else {
      squareColors[i] = topLeftHovered ? baseColors[i] : getShade(squareColors[i], false);
    }

    // Draw the square
    fill(squareColors[i]);
    int x = i == 0 || i == 2 ? 0 : squareSize;
    int y = i == 0 || i == 1 ? 0 : squareSize;
    rect(x, y, squareSize, squareSize);
  }
}

void renderDrawingCanvas() {
  canvas.beginDraw();
  
  // Draw the square tile background
  canvas.strokeWeight(1);
  canvas.stroke(0);
  canvas.fill(255);
  canvas.rect(0, 0, squareSize * 2, squareSize * 2);

  // Draw with mouse
  if (mousePressed) {
    canvas.strokeWeight(5);
    canvas.stroke(currentColor);
    canvas.line(pmouseX, pmouseY, mouseX, mouseY);
  }

  canvas.endDraw();
}

void draw() { 
  background(255);
  renderDrawingCanvas();
  image(canvas, 0, 0);
  drawSquares();
}
