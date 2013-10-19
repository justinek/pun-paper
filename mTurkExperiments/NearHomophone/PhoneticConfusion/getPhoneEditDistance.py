import sys, re, string, editdist

# get edit distance by phone

firstline = 0

phonesDict = dict()

f = open("../Materials/nearPuns_phones.txt", "r")

for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.replace("\n", "")
        toks = l.split("\t")
        phones1 = toks[4].split()
        for p in phones1:
            phonesDict[p] = 1
        phones2 = toks[5].split()
        for p in phones2:
            phonesDict[p] = 1

# print len(phonesDict.keys())

# make dictionary mapping phones onto distinct characters
i = 65
for p in phonesDict.keys():
    phonesDict[p] = chr(i)
    i = i + 1

f.close()

f = open("../Materials/nearPuns_phones.txt", "r")

firstline = 0
for l in f:
    l = l.replace("\n", "")
    if firstline == 0:
        toks = l.split("\t")
        print "\t".join(toks[0:6]) + "\tphoneDist"
        firstline = 1
    else:
        toks = l.split("\t")
        phones1 = toks[4].split()
        phones1_trans = []
        for p1 in phones1:
            t1 = phonesDict[p1]
            phones1_trans.append(t1)
        phones1_translated = "".join(phones1_trans)
        phones2 = toks[5].split()
        phones2_trans = []
        for p2 in phones2:
            t2 = phonesDict[p2]
            phones2_trans.append(t2)       
        phones2_translated =  "".join(phones2_trans)
        phoneDist =  editdist.distance(phones1_translated, phones2_translated)
        print "\t".join(toks[0:6]) + "\t" + str(phoneDist) + "\t" + str(len(phones1)) + "\t" + str(len(phones2))
