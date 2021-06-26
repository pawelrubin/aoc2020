#include <stdio.h>
#include <string.h>

#define MAX_LEN 256
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

struct Slope {
  int down;
  int right;
};

struct Slope slopes[] = {{.down = 1, .right = 1},
                         {.down = 1, .right = 3},
                         {.down = 1, .right = 5},
                         {.down = 1, .right = 7},
                         {.down = 2, .right = 1}};

int main() {
  FILE *fp = fopen("input.txt", "r");

  char lattice[1000][MAX_LEN];
  int size = 0;
  while (fgets(lattice[size], MAX_LEN, fp)) {
    // Remove trailing newline
    lattice[size][strcspn(lattice[size], "\n")] = 0;
    size++;
  }

  int row_size = strlen(lattice[0]);

  int result = 1;
  for (int s = 0; s < ARRAY_SIZE(slopes); s++) {
    struct Slope slope = slopes[s];
    int d = slope.down;
    int r = slope.right;

    int num_of_trees = 0;
    while (d < size) {
      if (lattice[d][r % row_size] == '#') {
        num_of_trees++;
      }
      d += slope.down;
      r += slope.right;
    }
    printf("slope: down -> %d right -> %d; num_of_trees = %d\n", slope.down,
           slope.right, num_of_trees);
    result *= num_of_trees;
  }
  printf("Final result: %d\n", result);
}