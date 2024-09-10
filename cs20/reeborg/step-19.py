import library as lib

put()
move()
while not object_here():
    if front_is_clear():
        move()
    elif not front_is_clear() and right_is_clear():
        lib.turn_right()
    else:
        turn_left()
    if wall_in_front():
        turn_left()