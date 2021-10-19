user_choice = -1 # creating var, to have it earlier than inputted one later (better for code)

tasks = [] #creating empty list
#tasks.append("Take out rubbish") #adding 2 tasks to list
#tasks.append("Clean the desk")

def delete_task():

    task_index = int(input("Type index of task you want to delete: ")) #recieving a var (index number) as integer, 
    if task_index <0 or task_index >len(tasks) -1:
        print ("Task not found")
        return

    tasks.pop(task_index) #deleting task index
    print ("Task has been deleted Succesfully!")

def save_tasks_to_file():
    file = open("tasks-list.txt", "w")
    for task in tasks:
        file.write(task+"\n")
    file.close()

def load_tasks_from_file():
    try:
        file = open("tasks-list.txt")
    
        for line in file.readlines():
            tasks.append(line.strip())

            file.close()
    except FileNotFoundError:
        return

def add_task():

     task = input("Describe a task: ")
     tasks.append(task) 
     print("Task added succesfully!")


def show_tasks(): #defying new function show_tasks

    task_index = 0 # setting starting index from 1 for value task from tasks list

    for task in tasks: #starting loop for, for indexing values in tasks list
        print("["+str(task_index) +"]" + task) # displaying tasks with indexes
        task_index += 1 # adding reccurence +1 for loop for

load_tasks_from_file()


while user_choice != 5: # doing loop while user_choice is different than 5
    if user_choice == 1: # cheking if user_choice is equal 1
        show_tasks()  

    if user_choice == 2: #checking if user_choice is equal 2
        add_task()
    
    if user_choice == 3:
        delete_task()

    if user_choice == 4:
        save_tasks_to_file()


    print()    
    print("1. Show tasks")
    print("2. Add task")    
    print("3. Delete a task")  # displaying user's options
    print("4. Save changes to file")
    print("5. Exit")
    print()

    user_choice = int(input("Choose a number: " "\n")) # integer input by user - becouse its list 1-5 we need integer
    print()
