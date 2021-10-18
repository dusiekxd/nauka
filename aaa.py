user_choice = -1 # creating var, to have it earlier than inputted one later (better for code)

tasks = [] #creating empty list
tasks.append("\n" "Take out rubbish") #adding 2 tasks to list
tasks.append("Clean the desk")

def show_tasks(): #defying new function show_tasks
    task_index = 0 # setting starting index from 0 for value task from tasks list
    for task in tasks: #starting loop for, for indexing values in tasks list
        print(task + " [" + str(task_index) + "]") # displaying tasks with indexes
        task_index += 1 # adding reccurence +1 for loop for


while user_choice != 5: # doing loop while user_choice is different than 5
    if user_choice == 1: # cheking if user_choice is equal 1
        show_tasks()  

    if user_choice == 2: #checking if user_choice is equal 2
        task = input("Describe a task: ") # declaring new var (task) and add its value by input
        tasks.append(task) #addig inputed value as new task to TASKS list

    #if user_choice == 3:
        

    print()    
    print("1. Show tasks")
    print("2. Add task")    
    print("3. Delete a task")  # displaying user's options
    print("4. Save changes to file")
    print("5. Exit")

    user_choice = int(input("Choose a number: " "\n")) # integer input by user - becouse its list 1-5 we need integer

