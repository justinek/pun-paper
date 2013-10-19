import sys, re, string

# read in "targetWords.csv" in the Materials folder
# and converts into input for mTurk experiment

f = open("../Materials/targetWords.csv", "r")
firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split(",")
        ID = toks[0]
        word1 = toks[1].upper()
        word2 = toks[2].upper()
        print '{"homophoneID":' + ID + ',"word1":"' + word1 + '","word2":"' + word2 + '"},'
