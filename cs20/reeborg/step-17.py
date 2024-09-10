import library as lib

while not at_goal():
    if front_is_clear():
        move()
    elif wall_in_front() and not wall_on_right():
        lib.turn_right()
    else:
        turn_left()