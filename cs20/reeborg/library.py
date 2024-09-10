
def turn_right():
    for i in range(3):
        turn_left()

def step(num_steps):
    for i in range(num_steps):
        move()

def plant(num_steps):
    for i in range(num_steps):
        move()
        put()
        
def discard(num_items):
    for i in range(num_items):
        put()

def turn(num_times):
    for i in range(num_times):
        turn_left()

def face_north():
    while not is_facing_north():
        turn_left()

def move_to_wall():
    while not wall_in_front():
        move()