/*
Sorting visualization
=====================
Abigail Adegbiji
November 28, 2024

Input size        | Compute times
------------------|-----------------
1000              | 7 ms
10,000            | 19 ms
100,000           | 1408 ms
1,000,000         | 148620 ms

Profiling hardware
------------------
OS: Ubuntu 24.10 x86_64
CPU: Intel i7-4600U (4) @ 3.300GHz
GPU: Intel Haswell-ULT
Memory: 7129 Mib

Excel gives us this equation that describes the time values:
y = 24074x^3 - 143757x^2 + 262764x - 143074
We know that 365.25 days = 31,557,600,000 ms.
So we can plug that into our equation and solve for y:
y = 24074(31557600000)^3 - 143757(31557600000)^2 + 262764(31557600000) - 143074
y = 7.5658923 * 10^35 = 756,589,230,000,000,000,000,000,000,000,000,000
So theoretically, sorting 7.5658923 hundred
decillion integer values would take 1 year.
*/

// Reference selection sort implementation
int[] selectionSort(int[] values) {
  int[] arr = values.clone();
  for (int i = 0; i < arr.length; i++) {
    int num = arr[i];

    // Find the smallest value after this point in the array
    int smallestIndex = 0;
    int smallest = Integer.MAX_VALUE;
    for (int j = i; j < arr.length; j++) {
      if (arr[j] < smallest) {
        smallest = arr[j];
        smallestIndex = j;
      }
    }

    // Swap the current value and the smallest value if needed
    if (smallest < num) {
      arr[i] = arr[smallestIndex];
      arr[smallestIndex] = num;
    }
  }
  return arr;
}

void profileSorting(int amount) {
  int[] values = new int[amount];
  for (int i = 0; i < amount; i++) {
    values[i] = (int)random(0, 5000);
  }

  int timeBefore = millis();
  selectionSort(values);
  int timeAfter = millis();
  System.out.printf("Time: %d ms", timeAfter - timeBefore);
}

int[] values;
int currentIndex;

int smallestIndex;
int smallestValue;
boolean swapping;

int iterations;
int comparisons;
int swaps;

color unsorted = color(255, 255, 255);
color sorted = color(59, 156, 56);
color current = color(0, 255, 0);
color smallest = color(255, 0, 0);
color transparent = color(0, 0, 0, 0);

void setup() {
  size(600, 400);
  textSize(20);
  initVisualizer();
}

void initVisualizer() {
  swapping = false;
  currentIndex = -1;
  smallestIndex = 0;
  smallestValue = 0;
  iterations = 0;
  comparisons = 0;
  swaps = 0;

  values = new int[50];
  for (int i = 0; i < values.length; i++) {
    values[i] = (int)random(10, 100);
  }
}

void drawValue(int i, int n, color c) {
  float h = n * 2.5;
  float w = width / values.length;
  if (alpha(c) == 0) {
    fill(0, 0, 0);
    stroke(0);
  } else {
    fill(c);
    stroke(0);
  }
  rect(i * w, height - h, w, h);
}

void visualizeSelection() {
  iterations++;
  ++currentIndex;
  if (currentIndex == values.length)
    return;

  // Find the smallest value after this point in the array
  smallestIndex = 0;
  smallestValue = Integer.MAX_VALUE;
  for (int j = currentIndex; j < values.length; j++) {
    iterations++;
    comparisons++;
    if (values[j] < smallestValue) {
      smallestValue = values[j];
      smallestIndex = j;
    }
  }

  if (smallestValue < values[currentIndex]) {
    comparisons++;
    swapping = true;

    // Hightlight the 2 values we'll swaps
    drawValue(currentIndex, values[currentIndex], current);
    drawValue(smallestIndex, smallestValue, smallest);
  }
}

void visualizeSwap() {
  swaps++;
  swapping = false;

  // Clear the previously highlighted values
  drawValue(currentIndex, values[currentIndex], transparent);
  drawValue(smallestIndex, values[smallestIndex], transparent);

  // Swap
  int n = values[currentIndex];
  values[currentIndex] = values[smallestIndex];
  values[smallestIndex] = n;

  // Draw the swapped values
  drawValue(currentIndex, values[currentIndex], smallest);
  drawValue(smallestIndex, values[smallestIndex], current);
}

void drawStats() {
  String prefix = currentIndex == values.length ? "Done sorting" : "Sorting";
  String status = String.format("%s %d values", prefix, values.length);
  String info = String.format("%d iterations, %d comparisons %d swaps\n", iterations, comparisons, swaps);
  fill(255, 255, 255);
  text(status, width/2 - textWidth(status) / 2, 20);
  text(info, width/2 - textWidth(info) / 2, 50);
}

void draw() {
  background(0);
  drawStats();

  for (int i = 0; i < values.length; i++) {
    color c = i < currentIndex ? sorted : unsorted;
    drawValue(i, values[i], c);
  }

  if (currentIndex < values.length) {
    // We're splitting the algorithm in two parts
    // so they can be visualized on separate frames
    if (swapping)
      visualizeSwap();
    else
      visualizeSelection();
    delay(100);
  } else if (keyPressed && key == ' ') {
    // Use the space key to restart the visualizer
    initVisualizer();
  }
}
