################# list

# # names_list = [] # empty list
# # names_list.append("Amadeusz") #append - adding
# # names_list.append("Wojciech")
# # names_list.append("Andrzej")

# # print(names_list)


#         #or

# # names_list = ["Amadeusz", "Wojciech", "Andrzej"]

# # print(names_list)

# #display specific elements of the list :

# #names_list = ["Amadeusz", "Wojciech", "Andrzej"]

# # # names_list.reverse()   - reversing results
# # names_list.sort()       # - sorting list

# # for name in names_list:
# #     print(name)

# names_list = ["Amadeusz", "Wojciech", "Andrzej", "Amadeusz"]
# #print(names_list[0]) # index starts from 0!, - first value of the list.
 
# # names_list.remove("Amadeusz") #remove deletes 1 "Amadeusz" from list
# # names_list.clear("Amadeusz")  # removes ALL "Amadeusz" from the list
# # print(names_list.count("Amadeusz")) #display how many "amadeusz" is in list.

# names_list2 = ["Agata"]

# names_list3 = names_list + names_list2

# print (names_list3)


#################### tuple   unchangable otherwise from LIST, can store different types of values


# person = ("Amadeusz", "Niemcewicz", 30 , "żonaty")  #using () instead of [] !

# print(person)

################# set - no duplicated data, not mutable (fe. no list/tuple within) , not sorted.

# empty set  names_set=set()
# adding to set   names_set.add("Dusiek")
# removing rom set  names_set.remove("Amadeusz")

# names_set = {"Amadeusz", "Wojciech" , "Andrzej" , "Wojciech"}
# #names_set.clear() - clears whole set.
# names_set.add ("Janusz")  # adding Janusz to name_set
# names_set2 = {"Zuzia", "Dominika", "Andrzej"}

# names_set3 = names_set.union(names_set2)   # adding names_set2 to names_set as result in names_set3
# #names_set3 = names_set.update(names_set2) # adding names_set2 to names_set !!
# #names_set3 = names_set.difference(names_set2) # diffrences between names_set and names_set2 - shows values from first set - names_set !
# #names_set3 = names_set.intersection(names_set2) # shows common results in these sets
# #names_set3 = names_set.symmetric_difference(names_set2) # shows result in set1 and set2 which aren't in BOTH sets !!!


# #print(names_set3)

# names_list = ["Artur", "Rafał"]

# names_list.extend(names_set3)  # adding names_list by result of SET names_set3.
# print (names_list)


################### Dictionary  TBC

#Dictionary = key & value

countries_and_capitals = {"Poland": "Warsaw", "Germany": "Berlin"}  # "Poland" is key, : "Warsaw" is value.
countries_and_capitals['Chechia'] = "Prague"  #adding new items to dictionary

#print(countries_and_capitals)


#for countrykey in countries_and_capitals.keys():   #displaying keys of our dictionary called countries_and_capitals
    #print(key)                                        


#for capitals in countries_and_capitals.values():   
#  print(capitals)                                   #displaying values of our dictionary called countries_and_capitals

#for country, capital in countries_and_capitals.items():   
#  print(country + " - " + capital)                        #displaying both keys and values separated by - character

#print (countries_and_capitals["Poland"]) # displaying value of key POLAND
#or
#print (countries_and_capitals.get("Poland"))

#print (countries_and_capitals["USA"])   # printing not extising key with result -  error
#print (countries_and_capitals.get("USA"))   # printing not extising key with result -  none

#print (countries_and_capitals.setdefault("USA", "Washington DC")) #adding USA Washington DC to dictionary
#print (countries_and_capitals)

if "Poland" in countries_and_capitals:#or ...capitals.keys():   #looking if POLAND is in our dictionary.
    print("Znaleziono!")
else:
        print("nie znaleziono")





