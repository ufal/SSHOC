__author__ = 'michaeldahnke'

import re

infile = open ('README.md', encoding='UTF-8')
data = infile.read()
infile.close()

x = input('Toss address, URL or whatsoever into it, else type in ›n‹.')

if x != 'n':
    data = re.sub(x, '[' + x + '](' + x + ')', data)

outfile = open('README.md', mode="w", encoding='UTF-8')
outfile.write(data)
outfile.close()
