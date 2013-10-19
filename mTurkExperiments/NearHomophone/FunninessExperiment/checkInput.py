import sys, re, string

f = open("experiment_input.txt", "r")

for l in f:
    l = l.replace("\n", "")
    l = l.replace('.?"', '."')
    print l
