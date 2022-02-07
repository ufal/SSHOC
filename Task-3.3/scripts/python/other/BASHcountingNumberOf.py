__author__ = 'Michael Dahnke'

# 1. CreateNamesOfDirectoriesFromAListOfFiles 
# 2. MoveFilesIntoRespectiveFolders.py

import re

outfile = open('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/toc_done.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()

infile = open('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/toc.txt', encoding='UTF-8')
lists = infile.readlines()
infile.close()

for list in lists:
    cyphers = re.search(r'\d+', list, re.U)
    cyphers = str(cyphers)
    cyphers = re.sub("<re\.Match object\; span=\(0, 6\), match='", '', cyphers, re.U)
    cyphers = re.sub("'>", '', cyphers, re.U)
    list = re.sub(cyphers, '', list, re.U)
    list = re.sub('.xml\n', '', list, re.U)
    list = str('cd ../txt/' + list + '/.; ls -1 | wc -l > ../' + list + '.txt; cd ../tei/.')
    outfile = open('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/toc_done.txt', mode='a', encoding='UTF-8')
    outfile.write(str(list))
    outfile.close()
