# inputs z-scored ratings in all conditions and converts into long form
# by matching each input to the appropriate sentence ID

import sys, re, string

# a dictionary mapping condition numbers to the unique IDs presented in the condition
conditionsDict = dict()

# open a .txt file containing [condition_num] [array of comma separated stimui IDs]
conditionsF = open(sys.argv[1], "r")
firstline = 0
for l in conditionsF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split("\t")
        condition_num = toks[0]
        IDs = toks[1]
        conditionsDict[condition_num] = IDs


# open the z-scored ratings file, also .txt
ratingsF = open(sys.argv[2], "r")

# fields in the long form
print "workerID,age,gender,language,condition,uniqueID,funniness,correctness"

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
        funninessRatingsArr = toks[5:64]
        correctnessRatingsArr = toks[64:123]
        IDsArr = conditionsDict[condition].split(",")

        #print funninessRatingsArr
        #print correctnessRatingsArr
        # conditions that have fewer trials
        if (condition == "6" or condition == "7"):
            if len(funninessRatingsArr) > len(IDsArr):
                #print "Short condition: " + condition
                funninessRatingsArr.pop();
                correctnessRatingsArr.pop();
        for i in range(len(IDsArr)):
            print workerID + "," + age + "," + gender + "," + language + "," + str(int(condition) + 1) + "," + IDsArr[i] + "," + funninessRatingsArr[i] + "," + correctnessRatingsArr[i]
            





