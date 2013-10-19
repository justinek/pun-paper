import sys, re, string

f = open("wordPairs_conditions.txt", "r")

currentCondition = 0
firstline = 0

for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        l = l.replace("#", "")
        toks = l.split("\t")
        condition = int(toks[0])
        uniquePairID = int(toks[1])
        homophone = toks[3].upper()
        word = toks[4].upper()
        if condition > currentCondition:
            currentCondition = condition
            print "],"
            print "["
        print '{"condition":' + str(condition) + ',"uniquePairID":' + str(uniquePairID) + ',"word1":"' + homophone + '","word2":"' + word +'"},' 
