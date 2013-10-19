import sys, re, string

f = open("../Materials/wordPairs_byCondition.csv", "r")

currentCondition = 0
firstline = 0

for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        condition = int(toks[7])
        uniquePairID = int(toks[0])
        homophone = toks[5].upper()
        word = toks[6].upper()
        if condition > currentCondition:
            currentCondition = condition
            print "],"
            print "["
        #print word
        print '{"condition":' + str(condition) + ',"uniquePairID":' + str(uniquePairID) + ',"word1":"' + homophone + '","word2":"' + word +'"},' 
