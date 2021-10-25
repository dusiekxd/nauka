#Write a Python program to get a new string from a given string where "Is" has been added to the front.
# If the given string already begins with "Is" then return the string unchanged



def new_string(str):  #declaring new defininition which creates var new_string
  if len(str) >= 2 and str[:2] == "Is":    # checking if lenght of var str is >= 2 and (both have to be true), str value containt 2 chars which are "IS" 
    return str
  return "Is" + str #adding IS before var

print(new_string("Array"))
print(new_string("IsEmpty"))

#output :

#IsArray
#IsEmpty