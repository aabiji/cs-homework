"""
Solution for "Extra - Double the Pile"

Walk up to the pile, take all of it, then place
double of what you took to the right.

Author: Abigail Adegbiji
Date: March 14, 2024
"""
import library as lib

# Walk up to the pile
while not object_here():
    move()

# Take all objects in pile
num_taken = 0
while object_here():
    num_taken += 1
    take()

# Discard twice the amount you took from the pile
move()
lib.discard(num_taken * 2)