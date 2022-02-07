__author__ = 'Michael Dahnke'

import re

outfile = open('xyz.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()

outfile = open('abc.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()

infile = open ('../../_french/theatre-classique-Auswahl/resultsFromNanettesList.txt', encoding='UTF-8')
resultsFromNanettesList = infile.readlines()
infile.close()

outfile = open('xyz.txt', mode="w", encoding='UTF-8')
outfile.write(str(resultsFromNanettesList))
outfile.close()

infile = open ('../../_french/theatre-classique-Auswahl/filesPickedUpManually.txt', encoding='UTF-8')
filesPickedUpManually = infile.readlines()
infile.close()

print(type(filesPickedUpManually))

filesPickedUpManually = str(filesPickedUpManually)

outfile = open('abc.txt', mode="w", encoding='UTF-8')
outfile.write(str(filesPickedUpManually))
outfile.close()

for filesPickedUpManually in resultsFromNanettesList:
    if resultsFromNanettesList not in resultsFromNanettesList:
        print(resultsFromNanettesList)
