import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;

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

color colorGrid[][];
Integer[] factors;
int factorIndex;

void generateColorGrid() {
  int numTiles = width / factors[factorIndex];
  colorGrid = new color[numTiles][numTiles];
  for (int y = 0; y < numTiles; y++) {
    for (int x = 0; x < numTiles; x++) {
      float r = random(0, 255);
      float g = random(0, 255);
      float b = random(0, 255);
      colorGrid[y][x] = color(r, g, b, 255);
    }
  }
}

void setup() {
  size(400, 400);
  stroke(0);
  factors = getFactors(width);
  factorIndex = factors.length / 2;
  generateColorGrid();
}

void keyPressed() {
  generateColorGrid(); 
}

void mousePressed() {
   if (mouseButton == RIGHT)
     factorIndex = max(0, factorIndex - 1);
  if (mouseButton == LEFT)
    factorIndex = min(factorIndex + 1, factors.length - 1);
  generateColorGrid();
}

void draw() {
  background(255);
  float size = factors[factorIndex];
  int numTiles = width / factors[factorIndex];
  for (int y = 0; y < numTiles; y++) {
    for (int x = 0; x < numTiles; x++) {
      fill(colorGrid[y][x]);
      rect(x * size, y * size, size, size);
    }
  }
}
