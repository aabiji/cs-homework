float squareColors[] = {255, 255, 255, 255};
int squareSize = 200;
int fadeSpeed = 5;
boolean topLeftClicked = false;
boolean bottomRightClicked = false;

void setup()
{
  size(400, 400);
}

void draw()
{ 
  background(255);

  // Mouse hover states in the 4 quadrants
  boolean hoverStates[] = {
    mouseX <= width / 2 && mouseY <= height / 2, // top left
    mouseX >= width / 2 && mouseY <= height / 2, // top right
    mouseX <= width / 2 && mouseY >= height / 2, // bottom left
    mouseX >= width / 2 && mouseY >= height / 2, // bottom right
  };
 
  if (topLeftClicked && !hoverStates[0])
    topLeftClicked = false;
  if (mousePressed && hoverStates[0])
    topLeftClicked = true;
  if (mousePressed && hoverStates[3]) {
    bottomRightClicked = true;
    squareColors = new float[]{255, 255, 255, 255};
  }

  // Draw the squares
  for (int i = 0; i < 4; i++) {
    // When the bottom right is clicked all squares should fade from white to black
    if (bottomRightClicked) {
      squareColors[i] -= fadeSpeed;
      if (squareColors[i] == 0)
        bottomRightClicked = false;
    } else {
      // Make square black on hover, else make it fade
      float c = hoverStates[i] ? 0 : min(squareColors[i] + fadeSpeed, 255);
      
      // If the top left square was clicked and the mouse is still on the top left square
      // all tiles should be black
      squareColors[i] = topLeftClicked ? 0 : c;
    }

    fill(squareColors[i]);
    stroke(0);
    int x = i == 0 || i == 2 ? 0 : squareSize;
    int y = i == 0 || i == 1 ? 0 : squareSize;
    rect(x, y, squareSize, squareSize);
  }
}
