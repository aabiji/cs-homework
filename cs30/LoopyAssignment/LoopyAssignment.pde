/*
Loopy Assignment
---------------
Abigail Adegbiji
October 11, 2024
*/

import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;

// Make sure the Sound library is installed
import processing.sound.SoundFile;

SoundFile effect1;
SoundFile effect2;
color colorGrid[][];
Integer[] factors;
int factorIndex;

// Algorithm + explanation taken from here:
// https://stackoverflow.com/questions/6800193/what-is-the-most-efficient-way-of-finding-all-the-factors-of-a-number-in-python
// If we use factors of the window size as square sizes, the drawn squares will always be right on the edge of the screen
Integer[] getFactors(int n) {
  Set<Integer> set = new HashSet<Integer>();
  
  // When multiplying 2 factors to get n, if one factor increases, the other needs to decrease
  // 1 of the factors will also be smaller or equal to the square root
  // So instead of checking each number from 1 to n to find factors
  // we can just search from 1 to the square root to find factor pairs.
  double root = Math.sqrt((double)n);
  int limit = (int)root + 1;
  for (int i = 1; i < limit; i++) {
    if (n % i == 0) {
      set.add(i);
      set.add(n / i);
    }
  }

  Integer[] factors = set.toArray(new Integer[set.size()]);
  Arrays.sort(factors); // Sort smallest to biggest
  factors = Arrays.copyOfRange(factors, 1, factors.length - 1); // Remove 1 and n
  return factors;
}

// Get a random color from our color palette
color getRandomColor() {
  color palette[] = {
    /* purple
    color(229, 217, 242),
    color(245, 239, 255),
    color(205, 193, 255),
    color(165, 148, 249)
    */
    color(227, 253, 253),
    color(203, 241, 245),
    color(166, 227, 233),
    color(113, 201, 206)
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
  size(400, 400);
  stroke(0);

  effect1 = new SoundFile(this, "sound-effect1.wav");
  effect2 = new SoundFile(this, "sound-effect2.wav");

  factors = getFactors(width);
  factorIndex = factors.length / 2;
  generateColorGrid();
}

void keyPressed() {
  generateColorGrid();
  effect1.play();
}

void mousePressed() {
   if (mouseButton == RIGHT)
     factorIndex = max(0, factorIndex - 1);
  if (mouseButton == LEFT)
    factorIndex = min(factorIndex + 1, factors.length - 1);
  effect2.play();
}

void draw() {
  background(255);
  
  // Draw a portion of the tiles
  float size = factors[factorIndex];
  int numTiles = width / factors[factorIndex];
  for (int y = 0; y < numTiles; y++) {
    for (int x = 0; x < numTiles; x++) {
      fill(colorGrid[y][x]);
      rect(x * size, y * size, size, size);
    }
  }
}
