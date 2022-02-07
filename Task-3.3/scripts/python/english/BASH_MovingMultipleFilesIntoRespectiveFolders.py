__author__ = 'Michael Dahnke'

## Create names of directoriers from a list of files generated with BASH command ls and stored into ›toc.txt‹

import re

outfile = open('/Users/michaeldahnke/Documents/corpora/software/scriptsForAll/BASH_CommandMovingMultipleFilesIntoRespectiveFolders.txt', mode='w', encoding='UTF-8')
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
    outfile = open('/Users/michaeldahnke/Documents/corpora/software/scriptsForAll/BASH_CommandMovingMultipleFilesIntoRespectiveFolders.txt', mode='a', encoding='UTF-8')
    outfile.write(str('; mv ' +list + '.*.txt ' + list + '/.'))
    outfile.close()
