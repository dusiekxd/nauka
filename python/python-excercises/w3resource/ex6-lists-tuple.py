# Write a Python program which accepts a sequence of comma-separated numbers from user
#  and generate a list and a tuple with those numbers.

# Sample data : 3, 5, 7, 23


# Output :
# List : ['3', ' 5', ' 7', ' 23']
# Tuple : ('3', ' 5', ' 7', ' 23')


values = input("input several comma-separated numbers: ") #taking input from user and declaring it to var values

list = values.split(",")  #splitting values by ","
tuple = tuple(list) # creating tuple 

print()
print('List : ',list)
print('Tuple : ',tuple)

