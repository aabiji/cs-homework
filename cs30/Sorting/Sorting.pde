/*
Sorting visualization
----------------------------
Abigail Adegbiji
November 22, 2024

Selection sort compute time:
Input size        | Computation Time
------------------|-----------------
1000              | 7 ms
10,000            | 26 ms
100,000           | 13331 ms
1,000,000         | 139492 ms
100,000,000       | 
4,508,228,571,430 | 365.25 days

365.25 days = 31,557,600,000 ms. It takes 7 ms
to sort 1000 ints so can sort 31557600000 / 7 = 4508228571.43
groups of 1000 ints in 1 year. In total, we can sort
4508228571.43 * 1000 = 4,508,228,571,430 ints in 1 year.
*/

int[] selectionSort(int[] values, boolean debug) {
  int[] arr = values.clone();
  int iterations = 0, comparisons = 0, swaps = 0;

  // Go through the array in 1 pass
  // O(n) to iterate the whole array, O(n) again to
  // find the smallest value. O(n) * O(n) = O(n ^ 2)
  // time complexity, so the algorithm is not very efficient.
  for (int i = 0; i < arr.length; i++) {
    iterations++;
    int num = arr[i];

    // Find the smallest value after this point in the array
    int smallestIndex = 0;
    int smallest = Integer.MAX_VALUE;
    for (int j = i; j < arr.length; j++) {
      iterations++;
      comparisons++;
      if (arr[j] < smallest) {
        smallest = arr[j];
        smallestIndex = j;
      }
    }

    // Swap the current value and the smallest value if needed
    comparisons++;
    if (smallest < num) {
      arr[i] = arr[smallestIndex];
      arr[smallestIndex] = num;
      swaps++;
    }
  }

  if (debug)
    System.out.printf("%d iterations, %d comparisons %d swaps\n", iterations, comparisons, swaps);

  return arr;
}

void profileSorting(int amount) {
  int[] values = new int[amount];
  for (int i = 0; i < amount; i++) {
    values[i] = (int)random(0, 5000);
  }

  int timeBefore = millis();
  selectionSort(values, true);
  int timeAfter = millis();
  System.out.printf("Compute time: %d ms", timeAfter - timeBefore);
}

int[] values = new int[50];

void setup() {
  size(600, 600);
  profileSorting(100000000);

  for (int i = 0; i < values.length; i++) {
    values[i] = (int)random(0, 100);
  } //<>//
}

void draw() {
  background(255);
  for (int i = 0; i < values.length; i++) {
    float h = values[i] * 2.5;
    rect(i * 20, height - h, 20, h);
  }
}
