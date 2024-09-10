import library as lib

def pick(facing_left):
    for i in range(2):
        move()
        take()
    lib.turn(2)
    lib.step(2)
    lib.discard(2)
    if facing_left:
        turn_left()
    else:
        lib.turn_right()

for i in range(2):
    move()
    turn_left()
    pick(True)

    move()
    lib.turn_right()
    pick(False)

lib.step(2)
