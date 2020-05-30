##################################################################################
# Justin Winfield
# Monday, October 8th
# I have not given or received any unauthorized assistance on this assignment
##################################################################################

def getColumn(variableName):
    "Retrieving a particular column from Avocado dataset"
    file = open("avocado.csv", "r")
    table = file.readlines()
    file.close()
    newList = []
    indexNumber = table[0].split(",").index(variableName) # Get the index for a given variable at splitting it into a list
    for row in table:
        makeList = row.split(",")
        grabCol = makeList[indexNumber]
        newList.append(grabCol)
    final = list(map(float, newList[1:]))
    return final


def readAndComputeMean_SM(columnName):
    "Computing the sample mean for a particular column"
    import statistics
    sampleMean = statistics.mean(getColumn(columnName))
    print("{0:.2f}".format(sampleMean))


def readAndComputeSD_SM(columnName):
    "Computing the sample standard deviation for a particular column"
    import statistics
    sampleSD = statistics.stdev(getColumn(columnName))
    print("{0:.2f}".format(sampleSD))


def readAndComputeMedian_SM(columnName):
    "Computing the sample median for a particular column"
    import statistics
    sampleMedian = statistics.median(getColumn(columnName))
    print("{0:.2f}".format(sampleMedian))

'''
mean_SM = readAndComputeMean_SM("Total Volume") # 850644.01
sd_SM = readAndComputeSD_SM("Total Volume") # 3453545.36
median_SM = readAndComputeMedian_SM("Total Volume") #107376.76
'''

def readAndComputeMean_HG(columnName):
    """Calculating the mean without using the statistics module"""
    x = getColumn(columnName)
    computedMean = sum(x)/len(x)
    return computedMean


def readAndComputeSD_HG(columnName):
    """Calculating standard deviation without using the statistics module"""
    import math
    x = getColumn(columnName)
    xbar = sum(x)/len(x) # Average
    diff = [xi - xbar for xi in x] # Get the difference from the instance to the average
    sqdiff = [sqd ** 2 for sqd in diff] # Square the difference
    sumsqdiff = sum(sqdiff)
    computedSD =  math.sqrt(sumsqdiff/(len(x)-1))
    return computedSD


def readAndComputeMedian_HG(columnName):
    """Calculating the median without using the statistics module"""
    x = getColumn(columnName)
    x.sort()
    length = len(x)
    if length % 2 == 1: # this is if the length of the variable is odd
        median = x[(length // 2)]
    else: # this is if the length of the variable is even
        median = x[(((length) // 2) + ((length + 1) // 2)) / 2]
    return median

'''
mean_HG = readAndComputeMean_HG("Total Volume")
print("{0:.2f}".format(mean_HG)) # 850644.01

sd_HG = readAndComputeSD_HG("Total Volume")
print("{0:.2f}".format(sd_HG)) # 3453545.36

median_HG = readAndComputeMedian_HG("Total Volume")
print("{0:.2f}".format(median_HG)) # 107376.76
'''

# Calcuating Mean, Standard Deviation, and Median without storing the chosen column in a list

def readAndComputeMean_MML(columnName):
    """Reading the column line by line and computing the average at that instance. Get the average at the end"""
    fakeSum = 0
    counter = 0
    for x in getColumn(columnName): # Getting the value at each line
        fakeSum += x
        counter += 1
        instAvg = fakeSum/counter
    return instAvg


x = readAndComputeMean_MML("Total Volume")
print(x) # 850644.0130089332