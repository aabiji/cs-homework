import library as lib

def draw1(going_up):
    if going_up:
        turn_left()
        lib.plant(5)
    else:
        lib.turn_right()
        put()
        lib.plant(4)
    if going_up:
        lib.turn_right()
    else:
        lib.turn_left()
    lib.step(2)

def draw0(going_down):
    lib.plant(2)
    if going_down:
        lib.turn_right()
    else:
        turn_left()
    lib.plant(4)
    if going_down:
        lib.turn_right()
    else:
        turn_left()
    lib.plant(2)
    if going_down:
        lib.turn_right()
    else:
        turn_left()
    lib.plant(4)
    if going_down:
        lib.turn_right()
    else:
        turn_left()
    lib.step(4)

move()
draw1(True)
draw0(True)
draw0(True)
draw1(False)
draw0(False)
lib.turn_right()
move()
