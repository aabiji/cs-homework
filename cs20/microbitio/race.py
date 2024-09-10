import microbit
import turtle
import random

window = turtle.Screen()
trump = turtle.Turtle()
trump.color("red")
biden = turtle.Turtle()
biden.color("blue")
presidency = turtle.Turtle()

# Move player1 and player2 to a start x location
def move_to_start(p1, p2, x):
    p1.penup()
    p2.penup()
    p1.goto(x, -20)
    p2.goto(x, 20)
    p1.pendown()
    p2.pendown()

def draw_finish_line(t, x):
    t.penup()
    t.goto(x, 100)
    t.pendown()
    t.right(90)
    t.forward(200)

# Clear button click cache
microbit.button_a.was_pressed()
microbit.button_b.was_pressed()

line_x = 200
move_to_start(trump, biden, -line_x)
draw_finish_line(presidency, line_x)

have_a_winner = False
while True:
    if microbit.button_a.was_pressed():
        trump.forward(random.randint(5, 20))
    if microbit.button_b.was_pressed():
        biden.forward(random.randint(5, 20))

    if not have_a_winner:
        if trump.xcor() > 200 or biden.xcor() > 200:
            have_a_winner = True
            if biden.xcor() > trump.xcor():
                print("Biden won!")
            elif trump.xcor() >= biden.xcor():
                print("Trump won!")

    if trump.xcor() > line_x and biden.xcor() > line_x:
        break