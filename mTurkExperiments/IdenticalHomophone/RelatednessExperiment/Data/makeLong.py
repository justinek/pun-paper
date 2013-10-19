# inputs cleaned up raw data in all conditions and converts into long form
# by matching each input to the appropriate pairID
# and also z-score all raw ratings

import numpy, math, sys, re, string

# open the ratings file (relatedness0113.results_clean.txt)
ratingsF = open(sys.argv[1], "r")

# fields in the long form
print "workerID,age,gender,language,condition,uniquePairID,wordOrder,order,relatedness"

firstline = 0
for l in ratingsF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split("\t")
        workerID = toks[0]
        age = toks[1]
        gender = toks[2]
        language = toks[3]
        condition = toks[4]
        pairIDsArr = toks[5].split(";")
        wordOrdersArr = toks[6].split(";")
        ordersArr = toks[7].split(";")
        relatednessArr = toks[8].split(";")
        
        # turn relatednessArr into floats
        relatednessArr = map(float, relatednessArr)
        # find the mean of the relatedness ratings for this subject
        relatednessMean = numpy.average(relatednessArr)
        # find sd
        relatednessSD = numpy.std(relatednessArr)

        relatednessZscoredArr = []
        for i in range(len(relatednessArr)):
            relatednessZscoredArr[i] = (relatednessArr[i] - relatednessMean) / relatednessSD

        for i in range(len(pairIDsArr)):
            print workerID + "," + age + "," + gender + "," + language + "," + condition + "," + pairIDsArr[i] + "," + wordOrdersArr[i] + "," + ordersArr[i] + "," + relatednessZscoredArr[i]





