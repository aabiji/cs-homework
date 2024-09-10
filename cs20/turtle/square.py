import turtle

pen_size = int(turtle.textinput("Color prompt", "Size of pen: "))
fg_color = turtle.textinput("Color prompt", "Color of turtle: ")
bg_color = turtle.textinput("Color prompt", "Color of background: ")
length = int(turtle.textinput("Color prompt", "Square side length: "))

canvas = turtle.Screen()
canvas.bgcolor(bg_color)

t = turtle.Turtle()
t.pensize(3)
t.color(fg_color)

for i in range(4):
    t.forward(length)
    t.right(90)