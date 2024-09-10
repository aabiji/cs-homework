"""
Solution for "Extra - Find the Centre 2"

Find the geometric center of the grid.

Author: Abigail Adegbiji
Date: March 13
"""

import library as lib

# Find the width
width = 0
while not wall_in_front():
    width += 1
    move()

turn_left()

# Find the height
height = 0
while not wall_in_front():
    height += 1
    move()

lib.turn(2)
# Go to center
for y in range(height // 2):
    move()

lib.turn_right()
for x in range(width // 2):
    move()

put()