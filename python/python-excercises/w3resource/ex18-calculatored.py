# Write a Python program to calculate the sum of three given numbers, if the values are equal then return thrice of their sum.


def sum_thrice(x, y, z):

    sum = x + y + z 

    if x == y == z:
        sum = sum * 3
    return sum


print(sum_thrice(1,2,3))









