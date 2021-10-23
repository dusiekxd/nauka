# Write a Python program that accepts an integer (n) and computes the value of n+nn+nnn.
# Sample value of n is 5
# Expected Result : 615


a = int(input("Input an integer : "))

n1 = int( "%s" % a )
n2 = int( "%s%s" % (a,a) )
n3 = int( "%s%s%s" % (a,a,a) )
print (n1+n2+n3)



#----------------------- %s meaning :
#in :


# a = 5
# n1 = int("%s" % a)   - %s - first value of var a  

#--------------------------
#other

# # declaring string variables

# str1 = 'Understanding',
# str2 = '%s'
# str3 = 'at'
# str4 = 'GeeksforGeeks'
  
# # concatenating strings
# final_str = "%s %s %s %s" % (str1, str2, str3, str4)
  
# # printing the final string
# print("Concatenating multiple strings using Python '%s' operator:\n")
# print(final_str)

#output : Understanding %s at GeeksforGeeks