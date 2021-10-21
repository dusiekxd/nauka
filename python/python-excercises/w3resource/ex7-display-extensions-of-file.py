# Write a Python program to accept a filename from the user and print the extension of that.
# Sample filename : abc.java
# Output : java


name = input("Write the name of a file: ")
file_extension = (name.split("."))


print("The extension of the file is : " + repr(file_extension[-1]))  #-1 becouse without first one part before dot ?

# The repr() function returns a printable representation of the given object.

#The syntax of repr() is:
#repr(obj)
