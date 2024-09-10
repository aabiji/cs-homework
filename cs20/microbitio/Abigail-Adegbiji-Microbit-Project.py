"""
Author: Abigail Adegbiji
Date: May 22, 2024

Description:
A recreation of Simon Says. A sequence of images will be shown to
the player and the player needs to play back those images in the
same order they appeared. If the user fails to do so, the game is restarted
from the beginning. If they succeed, the game progresses to the next level.
The game gets harder with each level with there being longer sequences
of images and faster playback times.

Exceptional features:
- Playing sound effects
  These docs will help: https://microbit.org/projects/make-it-code-it/make-some-noise
- Game progression with levels
- Extend the microbit library to support detecting when the microbit logo is touched
  This implementation might help: https://github.com/bbcmicrobit/micropython

Pseudocode:
say "Simon Says. Press the A button to start the game"

loop forever:
    if the player hasn't started the game and the a button is pressed:
        start the game

    if the game hasn't been started:
        jump to the next iteration of the loop

    if it's the player's turn:
        if the a button is pressed:
            display the corresponding image
            add that image to the player's inputted sequence of images

        if the b button is pressed:
            display the corresponding image
            add that image to the player's inputted sequence of images

        if the microbit logo is touched:
            it's our turn now

    if it's our turn:

        if the player has previously inputted a sequence:
            if the player's sequence is not the same as the sequence we showed them
                play the failure sound effect
                say "Game over"
                reset the playback speed back to normal
                reset the game (go back to the first level)
            else:
                progress to the next level (ex: level += 1)
                decrease the playback speed
                play the success sound effect
                say "Next level"

        say what level it is (ex: "Level 1")
        say "Simon Says"

        determine the length of the sequence based on the level

        generate a random sequence of images of that length:
            we have 2 different images we could choose from,
            so just iterate from 0 to the length of the sequence
            and add a randomly chosen image to our sequence each time

        for each image in our sequence:
            display the image
            pause for however many miliseconds our playback speed is

        it's the player's turn now
"""

import microbit
import random

# Run python code on the microbit
# The microbit's repl is implemented here:
# https://github.com/bbcmicrobit/micropython/blob/3e02466d13ef683fc14e2c3d78dd842d0c837d8d/tools/pyboard.py
# Under the hood, microbit uses a fork of micropython to run the code
def run_code(code):
    microbit.repl.send_command(code)
    response = microbit.repl.wait_response()
    if len(response) == 0:
        return None # Nothing to return
    return eval(response)

# Return True if the microbit logo is touched
# Touch detection of the logo is already implemented in microbit for us.
# See this commit: https://github.com/bbcmicrobit/micropython/commit/9ddc573245e9ce9f9d6c0b847b6597fece877af9.
# So really we just need to run this code: `microbit.pin_logo.is_touched()`
def logo_was_touched():
    # Print the value returned by pin_logo.is_touched()
    return run_code("print(pin_logo.is_touched())")

# Play a builtin microbit sound effect
def play_sound_effect(sound_effect_name):
    real_name = f"music.{sound_effect_name}"
    # Import musc, set the volume to 80, call the play function, pass in the sound effect name
    code = f"import music\nset_volume(80)\nmusic.play({real_name})"
    run_code(code)

def generate_sequence_of_images(level, images):
    sequence = []
    # Difficulty depends on the level. The more
    # images the player has to remember and play back,
    # the harder the game is.
    length = 2 * level
    # Iterate through and append a random image
    for i in range(0, length + 1):
        image = random.choice(images)
        sequence.append(image)
    return sequence

# Quickly show an image to the user
def flash_image(image, speed):
    microbit.display.show(image)
    microbit.sleep(speed)
    microbit.display.clear()
    microbit.sleep(speed)

# Return true if 2 lists are equal in content
def equals(a, b):
    if len(a) != len(b):
        return False
    for i in range(len(a)):
        if b[i] != a[i]:
            return False
    return True

game_has_started = False
is_players_turn = False

playback_speed = 1000 # In milliseconds
current_level = 0

our_sequence    = [] # Our (microbit) sequence of images
player_sequence = [] # Player's sequence of images
possible_images = [microbit.Image.YES, microbit.Image.NO] # Images we can choose from

success_sound_effect = "BA_DING"
failure_sound_effect = "POWER_DOWN"

# Reset the button caches
microbit.button_a.was_pressed()
microbit.button_b.was_pressed()

print("Here's instructions for attaching headphones to microbit: https://www.youtube.com/watch?v=4A-P2a4KFZc")
microbit.display.show("Simon Says. Press the A button to start")

while True:
    # Start the game with the A button
    if not game_has_started:
        if microbit.button_a.was_pressed():
            game_has_started = True
        microbit.display.clear()
        continue

    if is_players_turn:
        image_index = -1

        if microbit.button_a.was_pressed():
            image_index = 0 # YES image
        if microbit.button_b.was_pressed():
            image_index = 1 # NO image

        # Show the picked image
        if image_index != -1: # The player clicked a button
            image = possible_images[image_index]
            player_sequence.append(image)
            flash_image(image, 500)

        # The player's turn is over when the logo is pressed
        if logo_was_touched():
            is_players_turn = False

    else: # It's our turn

        if len(player_sequence) > 0: # Player inputted a sequence
            # Game over if the player's sequence is not the same as ours
            if not equals(our_sequence, player_sequence):
                play_sound_effect(failure_sound_effect)
                microbit.display.show("Game over")

                # Reset the playback speed and level
                player_sequence = [] # Reset the player sequence
                playback_speed = 1000
                current_level = 0
                continue
            else:
                # Progress to the next level, decrease the playback speed
                play_sound_effect(success_sound_effect)
                playback_speed = max(playback_speed - 50, 100)
                player_sequence = [] # Reset the player sequence
                current_level += 1

        message = f"Level {current_level + 1}. Simon Says:"
        microbit.display.show(message)

        # Show our sequence of images to the player
        our_sequence = generate_sequence_of_images(current_level, possible_images)
        for image in our_sequence:
            flash_image(image, playback_speed)

        is_players_turn = True