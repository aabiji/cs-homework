"""
Solution for "Step 15"

Go around the grid, putting walls at the left if there's none.

Author: Abigail Adegbiji
Date: March 12
"""

import library as lib

# Go to the left of the green square
move()
lib.turn_right()
move()

while not at_goal():
    if wall_in_front():
        turn_left()

    move()

    # Build missing wall
    if not wall_on_right():
        lib.turn_right()
        build_wall()
        turn_left()