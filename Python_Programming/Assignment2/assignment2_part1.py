##################################################################################
# Justin Winfield
# Monday, October 8th
# I have not given or received any unauthorized assistance on this assignment
##################################################################################

def readNameFile(filename):
    """Reading a file name"""
    file = open(filename)
    byLine = file.readlines()
    file.close()
    return byLine


def letterFreq(file):
    """Count the frequency of the last letter of someone's name"""
    letterDict = {}
    for name in file:
        name = name.strip() # Remove any whitespaces
        for char in name[-1]:
            if char in letterDict:
                    letterDict[char] += 1
            else:
                letterDict[char] = 1
    return letterDict


# Main Code

boys = readNameFile("namesBoys.txt")
boysLetter = letterFreq(boys)

girls = readNameFile("namesGirls.txt")
girlsLetter = letterFreq(girls)

alphaTable = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
              "u", "v", "w", "x", "y", "z"] # List of the alphabet


for i in range(len(alphaTable)): # Add any missing keys to the dictionary and set the value to 0
    if alphaTable[i] not in boysLetter:
        boysLetter[alphaTable[i]] = 0

for i in range(len(alphaTable)):
    if alphaTable[i] not in girlsLetter:
        girlsLetter[alphaTable[i]] = 0

boysSorted = sorted(boysLetter)
girlsSorted = sorted(girlsLetter)

print("{:9} {:5} {:5}".format("Endings", "Boys", "Girls"))
for key in boysSorted and girlsSorted:
    print("{:8} {:5} {:6}".format(key, boysLetter[key], girlsLetter[key]))




"""

There is interesting to see there are a lot more girls names ending in A from boys. Conversely, there are more boys 
names ending in N than girls. Also, its interesting that there are more boys names in different letters, which initial 
my initial assumption was that there would be more girls names with different letter endings given the more creative 
names are associated with girls.

"""