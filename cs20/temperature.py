"""
Temperature Conversion Assignment
Author: Abigail Adegbiji
Date: March 25

Ask the user for a input choice (a to f, quit or q).
If the user quits, print all the conversions from our history list and exit.
Else, map that input choice to a unit we'll convert from and a unit we'll convert to.
Use those from and to units to compute the converted temperature.
Append the conversion to a history list. And print the conversion.
"""

CONVERSION_HISTORY = []
CELSIUS = "c"
FAHRENHEIT = "f"
KELVIN = "k"

class Conversion:
    def __init__(self, from_unit, to_unit, temperature):
        self.from_unit = from_unit # Unit we're converting from
        self.to_unit = to_unit # Unit we're converting to
        self.before = temperature # Temperature in the unit we're converting from
        self.after = temperature # Temperature in the unit we're converting to

    def output(self):
        print(f"{self.before} °{self.from_unit.upper()} = {self.after} °{self.to_unit.upper()}\n")

    def convert(self):
        # Convert from farenheight to celcius or kelvin
        if self.from_unit == FAHRENHEIT and self.to_unit == CELSIUS:
            self.after = (self.before - 32) * (5 / 9)
        elif self.from_unit == FAHRENHEIT and self.to_unit == KELVIN:
            self.after = (self.before - 32) * (5 / 9) + 273.15

        #  Convert from celcius to farenheit or kelvin
        if self.from_unit == CELSIUS and self.to_unit == FAHRENHEIT:
            self.after = (self.before * (9 / 5)) + 32
        elif self.from_unit == CELSIUS and self.to_unit == KELVIN:
            self.after = self.before + 273.15

        # Convert from kelvin to celcius or farenheit
        if self.from_unit == KELVIN and self.to_unit == CELSIUS:
            self.after = self.before - 273.15
        elif self.from_unit == KELVIN and self.to_unit == FAHRENHEIT:
            self.after = (self.before - 273.15) * (9 / 5) + 32

def kelvin_convert(conversion):
    # Make sure a unit is converted to kelvin
    c = Conversion(conversion.to_unit, KELVIN, conversion.after)
    c.convert()
    return c.after

def log_conversion_history():
    global CONVERSION_HISTORY
    if len(CONVERSION_HISTORY) == 0:
        print("You haven't converted anything")
        return

    # Output all our conversions sorted by their
    # corresponding kelvin temperature (smallest to largest)
    print("\nYour conversions: ")
    CONVERSION_HISTORY.sort(key=kelvin_convert)
    for conversion in CONVERSION_HISTORY:
        conversion.output()

# Return true if the temperature for the specific
# unit isn't physically possible
def is_too_cold(unit, temperature):
    if unit == KELVIN and temperature < 0:
        return True
    elif unit == CELSIUS and temperature < -273.15:
        return True
    elif unit == FAHRENHEIT and temperature < -459.67:
        return True
    return False

def sanitize(user_input):
    return user_input.strip().lower()

print("This is a temperature conversion program. Enter 'q', 'Q', or 'quit' at any time to quit.")

units = ["c", "f", "k"]
while True:
    from_unit = sanitize(input("Which unit do you want to convert from: (C, F, K)? "))
    # Validate the input:
    # Break out of the loop if the user quits
    # Make sure the user inputs a valid unit
    if len(from_unit) > 0 and from_unit[0] == "q":
        break
    if len(from_unit) != 1 or from_unit not in units:
        print("You need to enter C, F, or K.")
        continue

    to_unit = sanitize(input("Which unit do you want to convert to: (C, F, K)? "))
    # Validate the input:
    # Break out of the loop if the user quits
    # Make sure the user inputs a valid unit
    if len(to_unit) > 0 and to_unit[0] == "q":
        break
    if len(to_unit) != 1 or to_unit not in units:
        print("You need to enter C, F, or K.")
        continue

    temperature = 0
    prompt = sanitize(input("Your temperature: "))
    # Validate the input:
    # Break out of the loop if the user quits
    # Make sure the user inputs a valid number
    try:
        temperature = float(prompt)
    except:
        if len(prompt) > 0 and prompt[0] == "q":
            break

        print("You need to need to enter a number.")
        continue

    # Doesn't make sense to convert if the temperature
    # is too cold
    if is_too_cold(from_unit, temperature):
        print("That's too cold!")
        continue

    # Convert, add the conversion to our history and output the result
    # of the conversion
    conversion = Conversion(from_unit, to_unit, temperature)
    conversion.convert()
    CONVERSION_HISTORY.append(conversion)
    conversion.output()

log_conversion_history()