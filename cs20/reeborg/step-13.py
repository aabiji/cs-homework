import library as lib

done = False
while not done:
    if front_is_clear() or right_is_clear():
        move()
    else:
        while not is_facing_north():
            turn_left()
        move()
        for i in range(2):
            lib.turn_right()
            move()
        turn_left()
    done = at_goal()
