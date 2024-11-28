/*
Sorting visualization
----------------------------
Abigail Adegbiji
November 28, 2024

Selection sort compute time:
Input size        | Computation Time
------------------|-----------------
1000              | 7 ms
10,000            | 19 ms
100,000           | 1408 ms
1,000,000         | 148620 ms

            .-/+oossssoo+/-.               aabiji@thinkpad 
        `:+ssssssssssssssssss+:`           --------------- 
      -+ssssssssssssssssssyyssss+-         OS: Ubuntu 24.10 x86_64 
    .ossssssssssssssssssdMMMNysssso.       Host: 20ARS1VL00 ThinkPad T440s 
   /ssssssssssshdmmNNmmyNMMMMhssssss/      Kernel: 6.11.0-9-generic 
  +ssssssssshmydMMMMMMMNddddyssssssss+     Uptime: 5 hours, 51 mins 
 /sssssssshNMMMyhhyyyyhmNMMMNhssssssss/    Packages: 2156 (dpkg), 13 (snap) 
.ssssssssdMMMNhsssssssssshNMMMdssssssss.   Shell: zsh 5.9 
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Resolution: 1366x768 
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   DE: GNOME 47.0 
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   WM: Mutter 
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   WM Theme: Adwaita 
.ssssssssdMMMNhsssssssssshNMMMdssssssss.   Theme: Yaru-blue [GTK2/3] 
 /sssssssshNMMMyhhyyyyhdNMMMNhssssssss/    Icons: Yaru-blue [GTK2/3] 
  +sssssssssdmydMMMMMMMMddddyssssssss+     Terminal: kitty 
   /ssssssssssshdmNNNNmyNMMMMhssssss/      CPU: Intel i7-4600U (4) @ 3.300GHz 
    .ossssssssssssssssssdMMMNysssso.       GPU: Intel Haswell-ULT 
      -+sssssssssssssssssyyyssss+-         Memory: 1892MiB / 7120MiB 
        `:+ssssssssssssssssss+:`
            .-/+oossssoo+/-.                                       
                                                                   
TODO: find better equation
The equation that describes the time values:
y = 31536x2 - 114502x + 87951
365.25 days = 31,557,600,000 ms. Plug it into the equation:
y = 31536(31557600000)^2 - 114502(31557600000) + 87951
y = 3.1406138e+25
So, sorting 3.1406138e+25 ints would take 1 year.
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

color base1 = color(209, 209, 209);
color base2 = color(28, 92, 61);
color highlight1 = color(59, 156, 56);
color highlight2 = color(196, 45, 45);
color transparent = color(255, 255, 255, 0);

void setup() {
  size(600, 400);
  textSize(20);

  swapping = false;
  currentIndex = -1;
  smallestIndex = 0;
  smallestValue = 0;
  iterations = 0;
  comparisons = 0;
  swaps = 0;

  values = new int[30];
  for (int i = 0; i < values.length; i++) {
    values[i] = (int)random(0, 100);
  }
}

void drawValue(int i, int n, color c) {
  float h = n * 2.5;
  float w = width / values.length;
  if (alpha(c) == 0) {
    fill(255, 255, 255);
    stroke(255);
  } else {
    fill(c);
    stroke(0);
  }
  rect(i * w, height - h, w, h);
}

void visualizeSelection() {
  iterations++;
  ++currentIndex;

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
    drawValue(currentIndex, values[currentIndex], highlight1);
    drawValue(smallestIndex, smallestValue, highlight2);
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
  drawValue(currentIndex, values[currentIndex], highlight2);
  drawValue(smallestIndex, values[smallestIndex], highlight1);
}

void draw() {
  background(255);

  String info = String.format("%d iterations, %d comparisons %d swaps\n", iterations, comparisons, swaps);
  String str = currentIndex == values.length ? info : "Sorting...";
  fill(0, 0, 0);
  text(str, 0, 20);

  for (int i = 0; i < values.length; i++) {
    color c = i < currentIndex ? base2 : base1;
    drawValue(i, values[i], c);
  }

  if (currentIndex < values.length) {
    // We're splitting the algorithm in two parts
    // so they can be visualized on separate frames
    if (swapping)
      visualizeSwap();
    else
      visualizeSelection();
    delay(500);
  }
}
