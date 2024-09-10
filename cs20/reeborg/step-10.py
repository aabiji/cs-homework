import library as lib

def jump_hurdle():
    move()
    turn_left()
    move()
    lib.turn_right()
    move()
    lib.turn_right()
    move()
    turn_left()

for i in range(6):
    jump_hurdle()
