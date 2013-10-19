import sys, string, re

def meanstdv(x):
    from math import sqrt
    n, mean, std = len(x), 0, 0
    for a in x:
        mean = mean + a
    mean = mean / float(n)
    for a in x:
        std = std + (a - mean)**2
    std = sqrt(std / float(n-1))
    return mean, std


# takes in funniness results for each subject and zscores

resultsField = "funniness"
resultsIndex = 0

f = open("../Data/data_lean.txt", "r")

print "workerid\tgender\tage\tcondition\tuniqueID\torders\tfunniness\tzscored"
firstline = 0
for l in f:
    l = l.replace("\n", "")
    l = l.replace('"', "")
    if firstline == 0:
        firstline = 1
        toks = l.split("\t")
        resultsIndex = toks.index(resultsField)
    else:
       toks = l.split("\t")
       results = toks[resultsIndex].split(",")
       results = [int(x) for x in results]
       [mean, std] = meanstdv(results)
       zscoredResults = [(x-mean)/std for x in results]
       zscoredResults = [str(x) for x in zscoredResults]
       print "\t".join(toks[0:resultsIndex + 1]) + "\t" + ",".join(zscoredResults)




