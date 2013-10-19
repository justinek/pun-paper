import sys, re, string, editdist

# computes the letter edit distance between two candidate words

f = open("../Materials/nearPuns_phones.txt", "r")

firstline = 0
for l in f:
    l = l.replace("\n", "")
    toks = l.split("\t")
    if firstline == 0:
        print "\t".join(toks[0:6]) + "\tletterDist"
        firstline = 1
    else:
        m1 = toks[2]
        m2 = toks[3]
        dist = editdist.distance(m1, m2)
        print "\t".join(toks[0:6]) + "\t" + str(dist)
