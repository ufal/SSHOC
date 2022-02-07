__author__ = 'michaeldahnke'

import re

# With this script a text file is searched line by line for all lines with letters; letters are exchanged with cypher 1.

outfile = open('fromLettersToCyphersResults.txt', mode="w", encoding='UTF-8')
outfile.write('')

infile = open ('fromLettersToCyphers.txt', encoding='UTF-8')
data = infile.readlines()
infile.close()

for line in data:
    if re.search(r'\W', line):
        line = re.sub('[A-Z]+.', '1', line)
        line = re.sub('-', '', line) 
        line = re.sub('1rrect?', 'Correct', line) 
        outfile = open('fromLettersToCyphersResults.txt', mode="a", encoding='UTF-8')
        outfile.write(str(line))
        outfile.close()
