# reads in wordPair_relatedness file and adds the unigram probability of content words

import sys, re, string

unigramF = open(sys.argv[1], "r")
unigramDict = dict()
firstline = 0
for l in unigramF:
    l = l.strip()
    if firstline == 0:
        firstline = 1
    else:
        toks = l.split(",")
        unigramDict[toks[0]] = toks[1]

f = open(sys.argv[2], "r")
firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        firstline = 1
        print l + ",unigram"
    else:
        toks = l.split(",")
        word = toks[5]
        prob = unigramDict[word]
        print l + "," + prob

    


