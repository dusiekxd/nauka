#Write a Python program to get the difference between a given number and 17, if the number is greater than 17 return double the absolute difference.

x = int(input("Type a number: "))


def difference(x):  #will return x as result!
    if x <= 17 :
        return x - 17
    else:
        return (x - 17) * 2

print (difference(x))

