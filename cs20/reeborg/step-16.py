import library as lib

turn_left()
lib.step(2)
lib.turn_right()
move()
move()

go_up = True
num_picked = 0
width, height = 6, 6
def stroll():
    global num_picked
    if object_here():
        take()
        num_picked += 1
    move()

for i in range(height):
    for i in range(width - 1):
        stroll()
    if go_up:
        turn_left()
        stroll()
        turn_left()
        go_up = False
    else:
        lib.turn_right()
        stroll()
        lib.turn_right()
        go_up = True
        
lib.turn_right()
lib.step(8)
turn_left()
lib.step(6)
lib.discard(num_picked)
