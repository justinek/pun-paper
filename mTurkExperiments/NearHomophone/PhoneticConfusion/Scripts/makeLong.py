import sys, re, string

# turn zscored data into long form

f = open("../Data/results_zscored.txt", "r")

subjectFields = ["workerID", "gender", "age"]
itemFields = ["homophoneID", "order", "confusability", "zscored"]

#subjectIndices = [0, 1, 2, 3]
#itemIndices = [4, 5, 6, 7]

print "workerID,gender,age,homophoneID,order,confusability,zscored"
firstline = 0
for l in f:
    l = l.replace("\n", "")
    toks = l.split("\t")
    if firstline == 0:
        firstline = 1
    else:
        numItems = len(toks[3].split(","))
        for n in range(numItems):
            print ",".join(toks[0:3]) + "," + toks[3].split(",")[n] + "," + toks[4].split(",")[n] + "," + toks[5].split(",")[n] + "," + toks[6].split(",")[n]

