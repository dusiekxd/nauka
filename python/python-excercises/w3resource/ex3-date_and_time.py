#Write a Python program to display the current date and time.


# import datetime
# now = datetime.datetime.now()
# print ("Current date and time: ")
# print (now.strftime("%Y-%m-%d %H:%M:%S"))


import datetime #importing datetime module 
now = datetime.datetime.now() #declaring new var now wchich shows current time
print ("Current date and time : ")
print (now.strftime("%d-%m-%Y %H:%M:%S")) # dis[laying time sorted
