import sys, re, string

f = open("experiment_input.txt", "r")

currentCondition = 0
for l in f:
    l = l.replace("\n", "")
    l = l.replace("#", "")
    toks = l.split("\t")
    condition = int(toks[0])
    uniqueID = int(toks[1])
    sentence = toks[2]
    if condition > currentCondition:
        currentCondition = condition
        print "],"
        print "["
    print '{"condition":' + str(condition) + ',"uniqueID":' + str(uniqueID) + ',"sentence":"' + sentence + '"},' 
