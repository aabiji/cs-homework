import microbit

def create_image(screen):
    result = ""
    for y in range(5):
        row = ""
        for x in range(5):
            row += str(screen[y][x])
        result += row + ":"
    return microbit.Image(result[:-1])

screen = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 9, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
]

# reset button click cache
microbit.button_a.was_pressed()
microbit.button_b.was_pressed()

x, y = 2, 2
while True:
    if microbit.button_a.was_pressed():
        screen[y][x] = 0
        x = x - 1 if x - 1 >= 0 else 4
        screen[y][x] = 9
    if microbit.button_b.was_pressed():
        screen[y][x] = 0
        y = y - 1 if y - 1 >= 0 else 4
        screen[y][x] = 9

    img = create_image(screen)
    microbit.display.show(img)
    microbit.sleep(500)