"""
5.9 Turtle Assignment One - Drawing Shapes
by Abigail Adegbiji
April 19, 2024

"Exceptional" features:
- You said that the user should be able to choose the shape color and size.
  So, I made sure that there input is valid. See the configure_shape function.
- I also decided to draw a fractal -- a Sierpiński triangle
"""

import math
import turtle

def goto(t, x, y):
    t.penup()
    t.goto(x, y)
    t.pendown()

# Draw a hexagon and return its width
def draw_hexagon(t, side_length, color):
    goto(t, t.xcor(), t.ycor() - side_length / 2)

    prev_x = t.xcor()
    farthest_x = 0

    angle = 360 // 6
    t.pencolor(color)
    for i in range(6):
        t.forward(side_length)
        t.left(angle)
        if i == 1:
            farthest_x = t.xcor()

    return farthest_x - prev_x

def draw_square(t, angle, width, height, color, start_in_middle=False):
    t.setheading(angle)
    t.pencolor(color)

    # Move halfway back
    if start_in_middle:
        t.left(180)
        t.forward(width / 2)
        t.left(180)

    for i in range(4):
        length = width if i % 2 == 0 else height
        t.forward(length)
        t.left(90)

    # Move back to the center position
    if start_in_middle:
        t.forward(width / 2)

def draw_triangle(t, angle, side_length, color, start_in_middle=False):
    t.setheading(angle)
    t.pencolor(color)

    # Move halfway back
    if start_in_middle:
        t.left(180)
        t.forward(side_length / 2)
        t.left(180)

    for i in range(3):
        t.forward(side_length)
        t.left(120)

    # Move back to the center position
    if start_in_middle:
        t.forward(side_length / 2)

# Draw a capital 'a' and return the width of the rendered letter
def draw_a(t, length, color):
    length = length + 10
    inner_length = length / 2
    base_length = length / 5
    bridge_length = length / 10
    arch_angles = [60, 300]
    previous_x, previous_y = t.xcor(), t.ycor()

    t.pencolor(color)

    # Draw an outer arch
    for i in range(2):
        t.setheading(arch_angles[i])
        t.forward(length)

    goto(t, previous_x, previous_y)

    # Draw the left letter base
    t.setheading(0)
    t.forward(base_length)

    # Draw an inner arch with a small bridge in the middle
    for i in range(2):
        t.setheading(arch_angles[i])
        t.forward(inner_length)
        if i == 0:
            t.setheading(0)
            t.forward(bridge_length)

    # Draw the right letter base
    t.setheading(0)
    t.forward(base_length)

    # We want to find the width of the area under the angled line
    half_length = length * math.cos(math.radians(arch_angles[0]))

    goto(t, previous_x + half_length, previous_y + half_length)
    draw_triangle(t, 0, bridge_length, color, start_in_middle=True)

    # Return the width of the rendered letter
    return half_length * 2

# Draw a capital 'b' and return the width of the rendered letter
def draw_b(t, length, color):
    x, y = t.xcor(), t.ycor()
    top_radius = length / 4
    bottom_radius = length / 3
    hole_radius = length // 11

    t.pencolor(color)

    # Draw line going up
    t.setheading(90)
    t.forward(length * 0.9)

    # Our "curves" are just circles rendered up to
    # a certain angle. Here we draw the bottom and top curves:
    goto(t, x, y)
    t.setheading(-30)
    t.circle(bottom_radius, 180)

    t.setheading(45) # 45 degree tilt
    t.circle(top_radius, 180)

    # Draw inner holes
    x, y = t.xcor(), t.ycor()
    hole_x = [
        x + top_radius / 2,  # Top hole
        x + top_radius / 1.5 # Bottom hole
    ]
    hole_y = [
        y - top_radius / 2, # Top hole
        (y - length) + bottom_radius * 1.25 # Bottom hole
    ]
    for i in range(2):
        goto(t, hole_x[i], hole_y[i])
        t.circle(hole_radius)

    return bottom_radius + top_radius

# Draw a capital 'g' and return the width of the rendered letter
def draw_g(t, size, color):
    edge_width = size / 5
    edge_height = size / 10
    outer_radius = size / 2
    inner_radius = size / 2.5
    outer_tilt, inner_tilt = 150, 145

    # Move right and upwards to preserve the position of the letter
    goto(t, t.xcor() + outer_radius * 1.8, t.ycor() + outer_radius * 1.8)
    x, y = t.xcor(), t.ycor()

    t.pencolor(color)

    # Draw outer curve
    t.setheading(outer_tilt)
    t.circle(outer_radius, 310)
    edge_x, edge_y = t.xcor(), t.ycor()

    # Draw top edge
    goto(t, x, y)
    t.setheading(270)
    t.forward(edge_height)

    # Draw inner curve
    t.setheading(inner_tilt)
    t.circle(inner_radius, 300)

    # Draw inner edge
    t.setheading(180)
    t.forward(edge_width)
    t.setheading(90)
    t.forward(edge_y - t.ycor())
    t.setheading(0)
    t.forward(edge_x - t.xcor())

    return outer_radius * 2

# Draw a capital 'i' and return the width of the rendered letter
def draw_i(t, size, color):
    width = size / 4
    height = size
    draw_square(t, 0, width, height, color)
    return width

# Draw a capital 'l' and return the width of the rendered letter
def draw_l(t, size, color):
    t.pencolor(color)

    edge_size = size / 4
    outer_length = size
    inner_length = outer_length - edge_size
    angles = [180, 90]

    end_x, end_y = t.xcor() + outer_length, t.ycor()
    goto(t, end_x, end_y)

    # Draw outer shape
    for a in angles:
        t.setheading(a)
        t.forward(outer_length)

    # Draw bottom right edge
    goto(t, end_x, end_y)
    t.forward(edge_size)

    # Draw inner shape
    for a in angles:
        t.setheading(a)
        t.forward(inner_length)

    # Draw top edge
    t.setheading(180)
    t.forward(edge_size)

    return outer_length

def draw_text(text, size, color):
    # Map letters to drawing functions
    drawers = {
        "a": draw_a,
        "b": draw_b,
        "g": draw_g,
        "i": draw_i,
        "l": draw_l,
    }

    spacing = 20
    x, y = t.xcor(), t.ycor()
    for c in text:
        width = drawers[c.lower()](t, size, color)
        x += width + spacing
        goto(t, x, y)

def draw_tesselation(t, length, color):
    t.pencolor(color)
    length /= 5

    num_sides = 8
    right_angle = 90
    center_x, center_y = t.xcor(), t.ycor()
    turns = [270, 45, 135, 315, 90, 315, 135, 45]
    for a in range(0, 360, 360 // num_sides):
        goto(t, center_x, center_y)

        # Draw the inner "crest"
        # Really it's composed of 8 squares connected 
        # to lines oriented at different angles
        t.setheading(a)
        t.forward(length)
        t.left(right_angle // 2)
        for i in range(6):
            t.forward(length)
            t.right(right_angle)

        # Draw the outer "crown" associated to the line
        t.setheading(a)
        t.forward(length + (length / 2))
        for i, turn in enumerate(turns):
            t.left(turn)
            t.forward(length + (length / 5))

# Draw a Sierpiński triangle
# A Sierpiński triangle is a fractal in the shape of a equilateral triangle
# Here's a really good explanation: https://en.wikipedia.org/wiki/Sierpi%C5%84ski_triangle
def draw_sierpinski(iterations, max_iterations, t, size, color):
    """
    We use the shrinking and duplication algorithm:
    We render 3 miniature triangles positioning them so that
    their corners touch those of the other 2 triangles.
    As such, the central hole is emergently created.
    We then repeat the entire algorithm for each miniature triangle.
    """
    triangle_positions = []
    scaled_size = size / 2

    triangle_positions.append(t.pos())
    draw_triangle(t, 0, scaled_size, color)

    t.forward(scaled_size)
    triangle_positions.append(t.pos())
    draw_triangle(t, 0, scaled_size, color)

    t.left(120)
    t.forward(scaled_size)
    triangle_positions.append(t.pos())
    draw_triangle(t, 0, scaled_size, color)

    # Render the child triangles recursively
    if iterations < max_iterations:
        for position in triangle_positions:
            goto(t, position[0], position[1])
            draw_sierpinski(iterations + 1, max_iterations, t, scaled_size, color)

def get_int():
    # Ensure that the user inputs a valid number by continuing to prompt them if they didn't
    while True:
        num_str = turtle.numinput("Configure shape", "Shape size", default=100, minval=50, maxval=600)
        try:
            num = int(num_str)
            return num
        except:
            pass

def get_color():
    # Ensure that the user inputs a valid color by continuing to prompt them if they didn't
    while True:
        color = turtle.textinput("Configure shape", "Shape color")
        try:
            temporary = turtle.Turtle()
            temporary.color(color)
            temporary.hideturtle()
            del temporary # Delete the object

            # Default to a white color
            if color == "":
                color = "white"
            return color
        except:
            pass

# Get the shape color and size from a GUi input
def configure_shape():
    return get_int(), get_color()

def draw_shapes(t):
    x, y = -270, 180
    padding = 20
    goto(t, x, y)

    size, color = configure_shape()
    width = draw_hexagon(t, size, color)
    x += width + padding

    # Draw composite triangle shape
    # For each of the 10 triangles, we'll draw them at the
    # different spots angled successively at (360 / 10) degrees
    num_triangles = 10
    x += size
    goto(t, x, y)
    size, color = configure_shape()
    for i in range(0, 360, 360 // num_triangles):
        draw_triangle(t, i, size, color)

    # Draw star shape
    # For each of the 5 triangles, we'll draw them at the
    # same spot angled successively at (360 / 5) degrees
    num_triangles = 5
    x += size * 2
    goto(t, x, y)
    size, color = configure_shape()
    for i in range(0, 360, 360 // num_triangles):
        draw_triangle(t, i, size, color, True)

    # Move down to the next line
    x = -270
    y -= size * 2
    # Draw composite square shape by drawing squares at different angles
    goto(t, x, y)
    size, color = configure_shape()
    angles = [90, 0, 270, 180]
    for a in angles:
        draw_square(t, a, size, size / 2, color)

    x += size * 2 + padding
    goto(t, x, y)
    size, color = configure_shape()
    draw_tesselation(t, size, color)

    x += size + padding
    y -= size
    goto(t, x, y)
    size, color = configure_shape()
    num = turtle.numinput("Configure fractal", "Number of iterations", default=3, minval=2, maxval=6)
    draw_sierpinski(0, int(num), t, size * 2.5, color)

    # Move down to the next line
    x = -300
    y -= size * 2
    goto(t, x, y)
    size, color = configure_shape()
    draw_text("abigail", size, color)

    canvas.exitonclick()

canvas = turtle.Screen()
canvas.setup(750, 650)
canvas.bgcolor("black")

t = turtle.Turtle()
t.pensize(1)
t.speed("slowest")

draw_shapes(t)