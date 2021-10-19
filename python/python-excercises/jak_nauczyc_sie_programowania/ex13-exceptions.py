countries_and_capitals = {'Poland' : 'Warsaw', 'Cechia': 'Prague', 'Germany': 'Berlin' }

#print (countries_and_capitals['USA']) #program ends if something is wrong

try:
    print(countries_and_capitals[USA])
except: # any exception, we should use except KeyError:
    print("Key not found")
finally: # will alwats execute, no matter of exceptions
    print("This will ALWAYS execute!")

print("im here")