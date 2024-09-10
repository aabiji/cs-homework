import microbit
import random

def create_microbit_image(row1, row2, row3, row4, row5):
    """Takes in 5 strings, each containing 5 integers.
    Returns an image that works on the micro:bit"""
    combined_string = f"{row1}:{row2}:{row3}:{row4}:{row5}"
    custom_image = microbit.Image(combined_string)
    return custom_image

empty = create_microbit_image("33333", "33333", "33333", "33333", "33333"),

dice = [
    create_microbit_image("33333", "30003", "30903", "30003", "33333"),
    create_microbit_image("33333", "39003", "30003", "30093", "33333"),
    create_microbit_image("33333", "39003", "30903", "30093", "33333"),
    create_microbit_image("33333", "39093", "30003", "39093", "33333"),
    create_microbit_image("33333", "39093", "30903", "39093", "33333"),
    create_microbit_image("33333", "39093", "39093", "39093", "33333"),
]

microbit.display.show(empty)
while True:
    if microbit.button_a.was_pressed():
        for i in range(3):
            random_dice = random.choice(dice)
            microbit.display.show(random_dice)
            microbit.sleep(500)