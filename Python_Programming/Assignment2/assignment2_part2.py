##################################################################################
# Justin Winfield
# Monday, October 8th
# I have not given or received any unauthorized assistance on this assignment
##################################################################################

def readTextFile(filename):
    """Reading a text file. Return the values in the file in a list"""
    file = open(filename, "r")
    inline = file.readlines()
    inline.sort()
    file.close()
    return inline


def vizStemLeaf(filename):
    "Visualize numbers in a text file as a Stem-Leaf Plot"
    numberDict = {}
    leafList = []
    read = readTextFile(filename)
    for number in read:
        removeLine = number.replace("\n", "") # Removing new lines from the file
        if len(removeLine) == 2: # Checking the length of the digit
            if removeLine[0] in numberDict: # If digit is in the dictionary, just update the list with the latest value
                leafList.append(removeLine[-1])
            else: # If digit is not in the dictionary, add it to the dictionary, and add new value to the cleared list
                leafList = []
                leafList.append(removeLine[-1])
                numberDict[removeLine[0]] = leafList
        if len(removeLine) > 2: # To handle any digits thats 3 or more in length
            if removeLine[:-1] in numberDict:
                leafList.append(removeLine[-1])
            else:
                leafList = []
                leafList.append(removeLine[-1])
                numberDict[removeLine[:-1]] = leafList
    for key, value in numberDict.items():
        print("{:2} |".format(key) + " ".join(value))


# Greet the user


name = input("Enter your name:  ")
print("Welcome, {}".format(name))


try:

    while True:
        option = eval(input("Select a file -- [1] Run 1.txt, [2] Run 2.txt, [3] Run 3.txt, [0] Exit: ")) # Ask the user to input 1, 2, or 3 -- loop until the user wishes to exit
        if option == 1:
            vizStemLeaf("StemAndLeaf1.txt")
        elif option == 2:
            vizStemLeaf("StemAndLeaf2.txt")
        elif option == 3:
            vizStemLeaf("StemAndLeaf3.txt")
        else:
            print("You must select 1, 2, 3, or 0!")


except NameError:
    print("Please provide a number")