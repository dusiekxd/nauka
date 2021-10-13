light = input("What's the light? (red, green, yellow)")

# if light == 'red':
#     print("WAIT!")
# elif light == 'yellow':
#     print("GET READY")
# elif light == 'green':
#     print ("GO!!")                 #elif = else if
# else:                       
#    print("Unknown command, type red, green, or yellow")


# with only 2 options , we can use this :

print("GO!") if light == 'green' else print ("Wait!")
