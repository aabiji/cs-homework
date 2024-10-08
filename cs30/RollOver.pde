/*
Tile draw
---------
Abigail Adegbiji - October 8, 2024
A drawing program that uses a rollover as a color palette.
Press down and move the mouse to draw.

Clicking the top left square  makes all the squares turn on
until the mouse moves outside of the square.
Clicking the bottom right square makes all the squares
fade from white to their respective colors. Clicking on
any of the squares changes the drawing color.

Right clicking on any of the tiles serves as an eraser,
changing the draw color to a transparent white.
*/

// Red, green, blue, yellow
color baseColors[] = {color(224, 108, 118), color(152, 195, 121), color(97, 175, 239), color(229, 192, 123)};
color squareColors[] = {baseColors[0], baseColors[1], baseColors[2], baseColors[3]};
color eraserColor = color(255, 255, 255, 255);

int squareSize = 50;
int currentColor = baseColors[0];
int penSize = 5;

boolean reverseFade = false;
boolean flashColors = false;
boolean hoverStates[]; // Mouse hover states for the 4 quadrants

PGraphics drawCanvas;

void setup() {
  size(600, 600);
  drawCanvas = createGraphics(600, 600);
}

void mouseWheel(MouseEvent event) {
  // Adjust pen size using the mouse wheel scrolling
  // Scrolling up makes the pen bigger, scrolling down makes it smaller
  float c = event.getCount();
  if (c >= 0)
    penSize = max(penSize - 5, 1);
  if (c <= 0)
    penSize += 5;
}

// Get different shades of a color by controlling its transparency
color getShade(color c, boolean getLighter) {
  float direction = getLighter ? -1 : 1;
  float t = alpha(c) - direction * 3;
  t = min(max(t, 0), 255); // Clamp transparency to be between 0 and 255
  return color(red(c), green(c), blue(c), t);
}

void mousePressed() {
  // Check if the top left square is clicked
  if (hoverStates[0])
    flashColors = true;

  // Check if the bottom right square is clicked
  if (hoverStates[3]) {
    reverseFade = true;
    // Make each square transparent
    for (int i = 0; i < 4; i++) {
      color c = baseColors[i];
      squareColors[i] = color(red(c), green(c), blue(c), 0); 
    }
  }

  for (int i = 0; i < 4; i++) {
    // Change the current color by left clicking on a qudrant
    if (hoverStates[i] && mouseButton == LEFT) {
      currentColor = baseColors[i];
      break;
    } else if (hoverStates[i] && mouseButton == RIGHT) {
      currentColor = eraserColor;
      break;
    }
  }
}

void drawSquares() {
  // We shouldn't be flashing colors if the cursor
  // is no longer in the top left quadrant
  if (flashColors && !hoverStates[0])
    flashColors = false;

  // We need to maintain the color we faded to until the
  // cursor is outside the bottom right square
  if (reverseFade && !hoverStates[3])
    reverseFade = false;

  // Mouse hover states in the 4 quadrants
  boolean left = mouseX <= squareSize;
  boolean right = mouseX >= squareSize && mouseX <= squareSize * 2;
  boolean top = mouseY <= squareSize;
  boolean bottom = mouseY >= squareSize && mouseY <= squareSize * 2;
  hoverStates = new boolean[]{left && top, right && top, left && bottom, right && bottom};

  for (int i = 0; i < 4; i++) {
    // The square should turn on when hovered on. The bottom right square
    // should also be fading when the other squares are fading
    if (hoverStates[i] && !(reverseFade && hoverStates[3])) {
      squareColors[i] = baseColors[i];
    } else if (reverseFade) {
      // When the bottom right is clicked all squares should fade from the white to their base color
      squareColors[i] = getShade(squareColors[i], true);
    } else {
      // If the top left square was clicked and the mouse is still on the top left square
      // all tiles should turn on. Else, the square color should fade.
      squareColors[i] = flashColors ? baseColors[i] : getShade(squareColors[i], false);
    }

    // Draw the square
    stroke(0);
    fill(squareColors[i]);
    int x = i == 0 || i == 2 ? 0 : squareSize;
    int y = i == 0 || i == 1 ? 0 : squareSize;
    rect(x, y, squareSize, squareSize);
  }
}

void renderDrawingCanvas() {
  drawCanvas.beginDraw();
  
  // Draw the square tile background
  drawCanvas.strokeWeight(1);
  drawCanvas.stroke(0);
  drawCanvas.fill(255);
  drawCanvas.rect(0, 0, squareSize * 2, squareSize * 2);

  // Draw with the mouse
  if (mousePressed) {
    drawCanvas.strokeWeight(penSize);
    drawCanvas.stroke(currentColor);
    drawCanvas.line(pmouseX, pmouseY, mouseX, mouseY);
  }

  drawCanvas.endDraw();

}

void drawPenColor() {
  // Draw the current color at the mouse position
  stroke(currentColor);
  if (currentColor == eraserColor)
    fill(128, 128, 128, 255);
  else
    fill(currentColor);
  ellipse(mouseX, mouseY, penSize, penSize); 
}

void draw() { 
  background(255);
  renderDrawingCanvas();
  image(drawCanvas, 0, 0);
  drawSquares();
  drawPenColor();
}
