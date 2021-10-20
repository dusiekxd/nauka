#Write a Python program which accepts the radius of a circle from the user and compute the area.

from math import pi #importin pi from module math  

r = float(input("Input the radius of a circle: ")) #declaring var r as float and taking input of radius
print("the area of the circle with radius " + str(r) + " is: " +str(pi * r**2)) # converting r and result to string