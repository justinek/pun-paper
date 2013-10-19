import sys, re, string

# remove irrelevant fields and reorder fields

# relevants fields
fields = ["workerid", "Answer.gender", "Answer.age", "Answer.condition", "Answer.uniqueIDs", "Answer.orders", "Answer.funninessResults"]

f = open("../Data/data_raw_filterLanguage.txt", "r")

fieldsIndex = []

print "workerid\tgender\tage\tcondition\tuniqueIDs\torders\tfunniness"

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
