countries_information = {}
countries_information["Poland"] = ("Warsaw", 37.97)
countries_information["Germany"] = ("Berlin", 83.02)
countries_information["Slovakia"] = ("Bratyslava", 5.45)

#for country in countries_information.keys():
#    print(country)

# country = input ("Which country informations you want to display?")

# country_information = countries_information.get(country)

# print()
# print(country)
# print("------") 
# print("Capital: " + country_information[0])  #first value (capital name)
# print("Population in mln : " + str(country_information[1]))  #second value (population) #converting to string value


#or

# def show_country_info(country):   #defining new function named show_country_info
#     country_information = countries_information.get(country)

#     print()
#     print(country)
#     print("------") 
#     print("Capital: " + country_information[0]) 
#     print("Population in mln : " + str(country_information[1]))    

# country = input ("Which country informations you want to display?")
# show_country_info(country)  # calling function


#################################3


def display_sum(a, b):  # defining new function which accepts two vars a,b and printing result a + b
    print(a+b)

display_sum (2,3)

def calculate_sum(a, b):  # defining new function which accepts two vars a,b and RETURNS a + b
    return a + b  #return result


sum = calculate_sum(2, 3)
print(sum)