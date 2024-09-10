import library as lib

turn_count = 0
repeat 23:
    move()
    if wall_in_front():
        turn_left()
        turn_count += 1
    if object_here():
        take()
    if turn_count == 4:
        break
