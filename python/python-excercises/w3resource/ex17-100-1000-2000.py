#Write a Python program to test whether a number is within 100 of 1000 or 2000.

x = int(input("Type a number: "))

def near_thousand(x):
      return ((abs(1000 - x) <= 100) or (abs(2000 - x) <= 100))

    
print(near_thousand(x))




