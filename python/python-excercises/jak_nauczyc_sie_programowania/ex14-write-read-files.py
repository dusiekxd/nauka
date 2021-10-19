# file = open("name-of-a-file.txt") # name of a file.

# file = open("name-of-a-file.txt","r") # function read   
# file = open("name-of-a-file.txt","w") # function write
# file = open("name-of-a-file.txt","w+") # function write+read


file = open("new-file1.txt", "w+") # - creating and read a new file (locatation depedns of terminad pwd)

countries_and_capitals = {'Poland' : 'Warsaw',
                         'Cechia': 'Prague', 'Germany': 'Berlin'}

for country, capital in countries_and_capitals.items(): #items, becouse we want keys and values
    file.write(country + "-" + capital +"\n")

file.close()

###############
#reading file :

file = open("new-file1.txt")

for line in file.readlines():  # reading line by line by using for loop
    print(line.strip())  # strip - printing without spaces

    file.close()