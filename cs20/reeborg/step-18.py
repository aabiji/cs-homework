"""
Solution for "Step 18"

Pick up all flowers in the grid and depose them
at the top right corner of the grid, before coming
back to the bottom left corner of the grid.

Author: Abigail Adegbiji
Date: March 11
"""
import library as lib

# Go to bottom left corner (at the flag)
lib.face_north()
turn_left()
lib.move_to_wall()
turn_left()
lib.move_to_wall()
lib.turn(2)

# Move to wall, picking up flowers along the way
num_picked = 0
def stroll():
    global num_picked
    while True:
        while object_here():
            take()
            num_picked += 1
        if wall_in_front():
            break
        else:
            move()

# Pick flowers when going up,
# move over, then move to the bottom wall
while True:
    stroll()
    lib.turn_right()
    if wall_in_front(): # at the top right
        lib.discard(num_picked)
        break
    else:
        move()
    lib.turn_right()
    lib.move_to_wall()
    lib.face_north()

# Go to the flag
lib.turn_right()
lib.move_to_wall()
lib.turn_right()
lib.move_to_wall()