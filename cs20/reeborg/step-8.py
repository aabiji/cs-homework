import library as lib

move()
num_picked = 0
will_collide = False
while not will_collide:
    move()
    if object_here():
        take()
        num_picked += 1
    will_collide = wall_in_front()

lib.turn(2)
lib.step(12)
lib.discard(num_picked)
move()
