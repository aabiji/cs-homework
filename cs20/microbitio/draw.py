import turtle
import microbit

window = turtle.Screen()
t = turtle.Turtle()

while True:
    x = microbit.accelerometer.get_x()
    y = microbit.accelerometer.get_y()
    if x > 200 or x < -200:
        t.forward(x/50)
    if y > 200:
        t.right(y/50)
    elif y < -200:
        t.left((y * -1) / 50)