import PySimpleGUI as gui

import turtle, math

window = turtle.Screen()
window.bgcolor("green")
window.screensize(600, 600)

t = turtle.Turtle()
t.color("blue")
t.pensize(5)
t.pencolor("blue")

def goto(t, x, y):
    t.penup()
    t.goto(x, y)
    t.pendown()

goto(t, 0, 0)
t.stamp()

for i in range(12):
    angle = math.radians(i * (360 / 12))
    t.setheading(math.degrees(angle))
    x = math.cos(angle) * 80
    y = math.sin(angle) * 80
    goto(t, x, y)

    x += math.cos(angle) * 5
    y += math.sin(angle) * 5
    t.goto(x, y)

    x += math.cos(angle) * 20
    y += math.sin(angle) * 20
    goto(t, x, y)
    t.stamp()

window.exitonclick()