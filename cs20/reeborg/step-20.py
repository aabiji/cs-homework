"""
Solution for "Step 20"

Same objective as step 15, going around and 
putting walls at the right if there's none.
This time though, the area isn't a grid.

Author: Abigail Adegbiji
Date: March 13
"""

import library as lib

# Go to the right of the green square
lib.step(3)
lib.turn_right()
move()

def go_back():
    lib.turn(2)
    move()
    turn_left()

# Return true if reeborg is completely
# surrounded by spaces
def is_surrounded():
    move()
    if right_is_clear():
        go_back()
        return True
    go_back()
    return False

while not at_goal():
    if wall_in_front():
        turn_left()

    if right_is_clear():
        if is_surrounded():
            move() # Go down corner
        else:
            build_wall()
            turn_left()
    else:
        move()