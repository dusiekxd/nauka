name = "   uduSIeku"

# print(len(name))
# print(name.capitalize())
# print(name.upper())
# print(name.lower())


#name = "Amadeusz"

#print  name[0])     # = A  becouse it's counting from 0.
#print (name[0:2])  # = Am becouse it contains letter numbers 0 and 1 (without 2!!) in word Amadeusz
#print (name[3:])  # = deusz becouse from fourth letter to the end.
#print (name[-3:]) # = usz becouse last 3 letters.

# channel = "how to python" #result = how', 'to', 'python'
# print(channel.split(" "))   # character in bracket, which will separate the string

# join_string = "-"  # character in quote, which will join the string
# print (join_string.join(['how' , 'to' , 'python'])) #result = how-to-python

# print(name.startswith("d")) #checks if name starts with lower d letter, result in bool
# print(name.startswith("D")) #checks if name starts with capital d letter, result in bool


# print(name.endswith("k")) #checks if name ends with lower k letter, result in bool
# print(name.endswith("J")) #checks if name ends with capital J letter, result in bool

#print(name.rstrip("k"))  #delete last letter (k) from right side of string dusiek
#print(name.lstrip("d"))  #delete first letter (d) from left side of string dusiek

# print(name.strip("u")) #delete first and last letter (u) from right side of string udusieku
# print(name.strip())    # using .strip without argument will delete spaces of string    udusieku

# first_name = "Amadeusz"
# last_name = "Niemcewicz"

# print(first_name + " " + last_name)   # adding quotes will make space in result.

# #or we can use this way :

# join_string = " "
# print(join_string.join([first_name, last_name])) # 


james_bond = 7
print(str(james_bond).zfill(3))   #changing  var from int to string, and adding 00, to have max 3 numbers (with 7). result = 007
