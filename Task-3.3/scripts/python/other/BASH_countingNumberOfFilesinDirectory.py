__author__ = 'Michael Dahnke'

import re

outfile = open('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/BASH_countingNumberOfFilesinDirectory.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()

infile = open('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/toc.txt', encoding='UTF-8')
lists = infile.readlines()
infile.close()

for list in lists:
    list = str(re.sub('.xml\n', '', list, re.U))
    list = str('cd ../txt/' + list + '; ls -1 | wc -l > ../' +  list + 'NumberOfCharacters.txt; cd ../../tei; ')
    outfile = open('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/BASH_countingNumberOfFilesinDirectory.txt', mode="a", encoding='UTF-8')
    outfile.write(list)
    outfile.close()

 

