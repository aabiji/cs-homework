/*
Loopy Assignment
---------------
Abigail Adegbiji
October 15, 2024

This program draws a multicolored grid of squares.
Left clicking zooms the grid out and plays a sound effect,
right clicking zooms the grid in and plays another sound effect.
Pressing any key changes all the colors in the grid and plays yet
another sound effect.
*/

import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;

// Make sure the Sound library is installed
import processing.sound.SoundFile;

SoundFile effect1;
SoundFile effect2;
SoundFile effect3;

color colorGrid[][];
Integer[] factors;
int zoomLevel;

// Algorithm and explanation taken from here:
// https://stackoverflow.com/questions/6800193/what-is-the-most-efficient-way-of-finding-all-the-factors-of-a-number-in-python
// If we use factors of the window size as square sizes, the drawn squares will always be right on the edge of the screen
Integer[] getFactors(int n) {
  Set<Integer> set = new HashSet<Integer>();
  
  // When multiplying 2 factors to get n, if one factor increases, the other needs to decrease
  // 1 of the factors will also be smaller or equal to the square root
  // So instead of checking each number from 1 to n to find factors,
  // we can just search from 1 to the square root to find factor pairs.
  double root = Math.sqrt((double)n);
  for (int i = 1; i < (int)root + 1; i++) {
    if (n % i == 0) {
      set.add(i);
      set.add(n / i);
    }
  }

  Integer[] factors = set.toArray(new Integer[set.size()]);
  Arrays.sort(factors); // Sort from the smallest factor to biggest
  factors = Arrays.copyOfRange(factors, 1, factors.length - 1); // Remove 1 and n
  return factors;
}

// Get a random color from our color palette
color getRandomColor() {
  // Colors taken from the Atom One Dark colorscheme
  color palette[] = {
    color(224, 108, 118),
    color(152, 195, 105),
    color(229, 192, 123),
    color(97, 175, 239),
    color(197, 120, 221),
    color(86, 182, 204)
  };
  int i = (int)random(0, palette.length);
  return palette[i];
}

// Generate all the possible colors at once
void generateColorGrid() {
  int numTiles = factors[factors.length - 1];
  colorGrid = new color[numTiles][numTiles];
  for (int y = 0; y < numTiles; y++) {
    for (int x = 0; x < numTiles; x++) {
      colorGrid[y][x] = getRandomColor();
    }
  }
}

void setup() {
  size(450, 450);
  stroke(0);

  effect1 = new SoundFile(this, "casino1.mp3");
  effect2 = new SoundFile(this, "casino2.mp3");
  effect3 = new SoundFile(this, "win.wav");

  factors = getFactors(width);
  zoomLevel = factors.length / 2;
  generateColorGrid();
}

void keyPressed() {
  generateColorGrid();
  effect3.play();
}

void mousePressed() {
  // Left click to make the tiles smaller
  if (mouseButton == LEFT) {
     zoomLevel = max(0, zoomLevel - 1);
     effect1.play();
  }

  // Right click to make the tiles bigger
  if (mouseButton == RIGHT) {
    zoomLevel = min(zoomLevel + 1, factors.length - 1);
    effect2.play();
  }
}

void draw() {
  background(255);
  
  // Draw a portion of the color grid
  float size = factors[zoomLevel];
  int numTiles = width / factors[zoomLevel];
  for (int y = 0; y < numTiles; y++) {
    for (int x = 0; x < numTiles; x++) {
      fill(colorGrid[y][x]);
      rect(x * size, y * size, size, size);
    }
  }
}
