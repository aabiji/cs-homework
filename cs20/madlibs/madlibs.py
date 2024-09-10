"""
Abigail Adegbiji
Date: May 2, 2024

A program that allows the user to generate madlibs.
"""
import copy
import random
import PySimpleGUI as gui

# Read a file and returns all the lines it contains
def read_file_lines(filename):
    contents = ""
    with open(filename, "r") as file:
        contents = file.read()
    lines = contents.split("\n")
    return lines

# Return false if we don't have all the required text
# files that we'll randomly select words from
def should_auto_generate():
    required_files = ["nouns.txt", "names.txt", "past-tense-verbs.txt", "adjectives.txt"]
    for filename in required_files:
        try:
            read_file_lines(filename)
        except:
            return False
    return True

# I know this isn't good practice, but oh well
names = read_file_lines("names.txt")
verbs = read_file_lines("past-tense-verbs.txt")
adjectives = read_file_lines("adjectives.txt")
nouns = read_file_lines("nouns.txt")
animals = read_file_lines("animals.txt")
def get_random_word(word_type):
    if word_type == "verb":
        return random.choice(verbs)
    elif word_type == "noun":
        return random.choice(nouns)
    elif word_type == "adjective":
        return random.choice(adjectives)
    elif word_type == "animal":
        return random.choice(animals)
    return random.choice(names)

# Return a 2d array containing each word in each sentence
# ex: [
#         ["hello", "world!"] # list holding each word in the sentence
#     ]
def split_story(story_str):
    story = []
    lines = story_str.strip().split("\n")
    for line in lines:
        line = line.strip()
        if len(line) == 0:
            continue
        words = line.split(" ")
        story.append(words)
    return story

# Return all indexes of a word in a text
def get_occurences(text, word):
    indexes = []
    for y in range(len(text)):
        line = text[y]
        for x in range(len(line)):
            if text[y][x] == word:
                indexes.append([x, y])
    return indexes

# A class to group the word we want to replace,
# what type of word it is (noun, verb, adjective, etc) and
# what ending it should have (s, ", 's, etc).
class Replacement:
    def __init__(self, word, word_type, ending):
        self.word = word
        self.word_type = word_type
        self.ending = ending
        self.indexes = []  # [x, y] positions in a text where the word is found

class Story:
    def __init__(self, text_str, replacements, id):
        self.id = id
        self.text = split_story(text_str)
        self.reversed_text = []
        self.weird_text = []

        # Replacements map the user inputted word with the word
        # in the story it's supposed to replace
        self.prompts = {}
        for key in replacements:
            replacement = replacements[key]
            replacement.indexes = get_occurences(self.text, replacement.word)
            self.prompts[key] = replacement

    # If words is an empty list, we auto generate, picking random words from text files
    def generate(self, words):
        auto_generate = len(words) == 0

        # Get random words for each key once, to
        # make the story more cohesive
        random_words = {}
        for key in self.prompts:
            replacement = self.prompts[key]
            random_words[key] = get_random_word(replacement.word_type)

        # Generate the new story by replacing some words with user inputted words
        # Generate a "weird" version of the story by making each word in the story
        # uppercase and replacing each 'a' with 'o'
        for key in self.prompts:
            replacement = self.prompts[key]
            for index in replacement.indexes:
                x, y = index[0], index[1]
                if auto_generate:
                    word = random_words[key] + replacement.ending
                else:
                    word = words[key] + replacement.ending
                self.text[y][x] = word

        # Make each word uppercase and replace the 'a' with 'o'
        # Generate a "reversed" version of the story by making each user word reversed
        self.weird_text = copy.deepcopy(self.text)
        self.reversed_text = copy.deepcopy(self.text)
        for y in range(len(self.weird_text)):
            line = self.weird_text[y]
            for x in range(len(line)):
                string =  self.weird_text[y][x].replace("a", "o").upper()
                self.weird_text[y][x] = string
                self.reversed_text[y][x] = self.reversed_text[y][x][::-1]

    def build_ui(self):
        inputs = []
        labels = []

        # Render each input labels in a column and all input fields in another column
        for p in self.prompts:
            labels.append([gui.Text(p)])
            inputs.append([gui.InputText(size=25, key=p)])

        # Only add the auto generation feature when we have
        # the necessary files
        generation_buttons = [gui.Button("Generate")]
        if should_auto_generate():
            generation_buttons.append(gui.Button("Auto Generate"))

        left_side = [
            [gui.Column(labels), gui.Column(inputs)],
            generation_buttons
        ]

        right_side = []
        # Render each line of the story on different lines
        for i in range(len(self.text)):
            line = " ".join(self.text[i])
            # The text_id_prefix is used to differentiate between text from
            # the different stories
            right_side.append([gui.Text(line, key=f"{self.id}{i}")])

        right_side.append([
            gui.Button("Normal version"), gui.Button("Weird version"), gui.Button("Reversed version")
        ])

        return [[gui.Column(left_side), gui.Column(right_side)]]

# Update the displayed text
def update_text(window, id_prefix, text):
    for i in range(len(text)):
        line = " ".join(text[i])
        window[f"{id_prefix}{i}"].update(line)

humpty_dumpty = """
Humpty Dumpty sat on a wall,
Humpty Dumpty had a great fall.
All the king's horses and all the king's men.
Couldn't put Humpty together again.
"""
replacements = {
    "Person's First Name": Replacement("Humpty", "name", ""),
    "Person's Last Name": Replacement("Dumpty", "name", ""),
    "Verb (past tense action": Replacement("sat", "verb", ""),
    "Job Title": Replacement("king's", "noun", "'s"),
    "Animal": Replacement("horses", "animal", "s")
}
story1 = Story(humpty_dumpty, replacements, "p1-")

buckle_my_shoe = """
One, two
Buckle my shoe
Three, four
Knock at the door
Five, six
Pick up sticks
Seven, Eight
Lay them straight
Nine, ten
A big fat hen
"""
replacements = {
    "Footwear": Replacement("shoe", "noun", ""),
    "House item": Replacement("door", "noun", ""),
    "Object": Replacement("sticks", "noun", "s"),
    "Direction": Replacement("straight", "adjective", ""),
    "Creature": Replacement("hen", "animal", "")
}
story2 = Story(buckle_my_shoe, replacements, "p0-")

# Gui layout for the main menu
menu_layout = [
    [gui.Text("Which story do you want?")],
    [gui.Button("Humpty Dumpty"), gui.Button("Buckle My Shoe")]
]

# The different "screens" in the gui
layouts = [[
    gui.Column(menu_layout, key="Main Menu", visible=True),
    gui.Column(story1.build_ui(), key="UI-1", visible=False),
    gui.Column(story2.build_ui(), key="UI-2", visible=False),
]]

window = gui.Window("Madlibs", layouts)
story = None # Will be a Story object when we choose which story in the main menu

while True:
    event, values = window.read()
    if event == gui.WINDOW_CLOSED:
        break

    # Change layout based on button click
    if event == "Humpty Dumpty" or event == "Buckle My Shoe":
        window["Main Menu"].update(visible=False)
        if event == "Humpty Dumpty":
            story = story1
            window["UI-1"].update(visible=True)
        else:
            story = story2
            window["UI-2"].update(visible=True)

    # Generate the madlibs when the "Generate" button is clicked
    if "Generate" in event:
        # Only generate when all fields are filled in
        should_generate = True
        for key in story.prompts:
            if values[key] == "":
                should_generate = False
                break
        if should_generate:
            story.generate(values)
            update_text(window, story.id, story.text)

    # Auto generate the madlibs when the "Auto generate" button is clicked
    if "Auto Generate" in event:
        story.generate([])
        update_text(window, story.id, story.text)

    # Switch to different versions of the story on button click
    if "Weird version" in event:
        update_text(window, story.id, story.weird_text)
    elif "Reversed version" in event:
        update_text(window, story.id, story.reversed_text)
    elif "Normal version" in event:
        update_text(window, story.id, story.text)

window.close()