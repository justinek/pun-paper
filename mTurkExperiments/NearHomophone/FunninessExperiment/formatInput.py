import sys, re, string

f = open("../Materials/sentences_byCondition.txt", "r")

firstline = 0
currentCondition = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        l = l.replace('"', "")
        toks = l.split("\t")
        condition = int(toks[7])
        uniqueID = int(toks[0])
        sentence = toks[4]
        if condition > currentCondition:
            currentCondition = condition
            print "],"
            print "["
        print '{"condition":' + str(condition) + ',"uniqueID":' + str(uniqueID) + ',"sentence":"' + sentence + '"},' 
