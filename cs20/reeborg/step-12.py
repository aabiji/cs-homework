import library as lib

turn_left()
lib.step(2)
lib.turn_right()
move()

num_apples = 0
while object_here():
    take()
    num_apples += 1

lib.turn_right()
lib.step(3)
turn_left()
lib.step(4)
turn_left()
lib.step(4)
lib.discard(num_apples)

lib.turn(2)
lib.step(4)
lib.turn_right()
lib.step(5)
turn_left()
lib.step(2)
