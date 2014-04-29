# Find the indices of support words in the sentence

import sys, re, string, numpy

f = open(sys.argv[1], "r")

firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        print l + ",m1indices,m2indices,length,avePosition1,avePosition2"
        firstline = 1
    else:
        toks = l.split(",")
        words = toks[4].lower().replace(":", "").replace("#", "").replace(".", "").replace("?", "").replace("!", "").replace(";", "").split()
        m1focus = toks[11].split(";")
        m2focus = toks[12].split(";")
        if m1focus[0] == '':
            m1indices = ["-1"]
        else:
            m1indices = [str(words.index(x)) for x in m1focus]
            avePosition1 = str(numpy.mean([words.index(x) for x in m1focus]))
        if m2focus[0] == '':
            m2indices = ["-1"]
        else:
            m2indices = [str(words.index(x)) for x in m2focus]
            avePosition2 = str(numpy.mean([words.index(x) for x in m2focus]))
        print l + "," + ";".join(m1indices) + "," + ";".join(m2indices) + "," + str(len(words)) + "," + avePosition1 + "," + avePosition2
