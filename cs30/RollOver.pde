/*
Rollovers
---------
Abigail Adegbiji - October 4, 2024

TODO: extra feature?????
*/

color baseColors[] = {
  color(224, 108, 118), // red
  color(152, 195, 121), // green
  color(97, 175, 239), // blue
  color(229, 192, 123) // yellow
};
color squareColors[] = {baseColors[0], baseColors[1], baseColors[2], baseColors[3]};
boolean topLeftClicked = false;
boolean bottomRightClicked = false;

// Get different shades of a color by controlling its transparency
color getShade(color c, boolean up) {
  float direction = up ? -1 : 1;
  float t = alpha(c) - direction * 5;
  t = min(max(t, 0), 255);
  return color(red(c), green(c), blue(c), t);
}

void setup() {
  size(400, 400);
  stroke(0);
}

void draw() { 
  background(255);

  // Mouse hover states in the 4 quadrants
  boolean hoverStates[] = {
    mouseX <= width / 2 && mouseY <= height / 2, // top left
    mouseX >= width / 2 && mouseY <= height / 2, // top right
    mouseX <= width / 2 && mouseY >= height / 2, // bottom left
    mouseX >= width / 2 && mouseY >= height / 2, // bottom right
  };

  // Check if the top left square is clicked
  if (topLeftClicked && !hoverStates[0])
    topLeftClicked = false;
  if (mousePressed && hoverStates[0])
    topLeftClicked = true;

  // Check if the bottom right square is clicked
  if (mousePressed && hoverStates[3]) {
    bottomRightClicked = true;
    // Make each square transparent
    for (int i = 0; i < 4; i++) {
      color c = baseColors[i];
      squareColors[i] = color(red(c), green(c), blue(c), 0); 
    }
  }

  for (int i = 0; i < 4; i++) {
    // The square should turn on when hovered on
    if (hoverStates[i]) {
      // TODO: including the bottom right square!
      squareColors[i] = baseColors[i];
    }

    // When the bottom right is clicked all squares should fade from the white to their base color
    else if (bottomRightClicked) {
      squareColors[i] = getShade(squareColors[i], true);
      if (squareColors[i] == baseColors[i])
        bottomRightClicked = false;
    }

    // If the top left square was clicked and the mouse is still on the top left square
    // all tiles should turn on. Else, the square color should fade.
    else {
      squareColors[i] = topLeftClicked ? baseColors[i] : getShade(squareColors[i], false);
    }

    // Draw the square
    fill(squareColors[i]);
    int x = i == 0 || i == 2 ? 0 : width / 2;
    int y = i == 0 || i == 1 ? 0 : height / 2;
    rect(x, y, width / 2, height / 2);
  }
}
