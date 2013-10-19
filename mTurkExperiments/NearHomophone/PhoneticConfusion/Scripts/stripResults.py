import sys, re, string

# remove irrelevant fields and reorder fields

# relevants fields
fields = ["workerid", "Answer.gender", "Answer.age", "Answer.homophoneIDs", "Answer.orders", "Answer.results"]

f = open("../Data/results_filteredLanguage.txt", "r")

fieldsIndex = []

print "workerid\tgender\tage\thomophoneIDs\torders\tconfusability"

firstline = 0
for l in f:
    l = l.replace("\n", "")
    l = l.replace('"', "")
    if firstline == 0:
        firstline = 1
        toks = l.split("\t")
        for field in fields:
            fieldsIndex.append(toks.index(field))
    else:
        l = l.translate(None, "[]")
        toks = l.split("\t")
        for index in fieldsIndex:
            print toks[index] + "\t",
        print "\n",
