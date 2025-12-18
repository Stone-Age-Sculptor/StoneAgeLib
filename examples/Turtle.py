# Turtle.py
#
# by Stone Age Sculptor
# License CC0
#
# Version 1
# February 3, 2025

# A test for the Python Turtle graphics.
# To test if a similar result can be achieved in OpenSCAD.

# In linux, I had to install the python3-tk package.

import turtle
import platform

print("Using Python version:", platform.python_version())
print("Click on the graphical window to stop.")

# Not every Turtle version has a "_ver" string.
# print(turtle._ver)

window = turtle.Screen()
window.bgcolor("#FFFFFF")
turtle.setworldcoordinates(-60,-60,60,60)

# only use the line, hide the turtle
turtle.hideturtle()

# zero is the highest speed.
# 1 is normal speed, 2 is faster.
turtle.speed(10)

# A dark blue color
turtle.color("#0000A8")

# The turtle starts at (0,0) with angle 0.

turtle.penup()
turtle.home()
turtle.goto(-47,-15)
turtle.pensize(8)
turtle.pendown()

turtle.setheading(130)
for x in range(6):
    turtle.circle(-5,260)
    turtle.circle(5,260)

turtle.penup()
turtle.home()
turtle.goto(-47,-45)
turtle.pensize(18)
turtle.pendown()

turtle.left(90)
for x in range(12):
    turtle.forward(14)
    turtle.circle(-2,180)
    turtle.forward(14)
    turtle.circle(2,180)

turtle.penup()
turtle.home()
turtle.goto(-52,15)
turtle.pensize(3)
turtle.pendown()

turtle.left(100)
turtle.forward(3.2)
turtle.right(120)
turtle.forward(2)
turtle.left(60)
turtle.forward(12)
turtle.circle(8,110)
turtle.right(140)
turtle.circle(16,80)
turtle.right(130)
turtle.circle(16,77)
turtle.right(120)
turtle.circle(12,90)
turtle.right(130)
turtle.circle(12,80)
turtle.right(130)
turtle.circle(12,80)
turtle.right(120)
turtle.circle(16,80)
turtle.right(130)
turtle.circle(11.6,123)
turtle.forward(7.6)
turtle.left(60)
turtle.forward(2)

turtle.penup()
#turtle.goto(10,10)
turtle.home()
turtle.pensize(3)
turtle.pendown()

turtle.forward(15)
turtle.left(180)
turtle.circle(-5,160)
turtle.forward(1)
turtle.circle(2.5,160)
turtle.setx(0)

turtle.exitonclick()
  
