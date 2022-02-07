__author__ = 'Michael Dahnke'

## Create names of directories from a list of files generated with BASH command ls and stored into ›toc_done.txt‹

import re

outfile = open('toc_done.txt', mode='w', encoding='UTF-8')
outfile.write('mkdir ../txt; ')
outfile.close()

infile = open('toc.txt', encoding='UTF-8')
lists = infile.readlines()
infile.close()

for list in lists:
    cyphers = re.search(r'\d+', list, re.U)
    cyphers = str(cyphers)
    cyphers = re.sub("<re\.Match object\; span=\(0, 6\), match='", '', cyphers, re.U)
    cyphers = re.sub("'>", '', cyphers, re.U)
    list = re.sub(cyphers, '', list, re.U)
    list = re.sub('.xml\n', '', list, re.U)
    list = str('mkdir ../txt/' + list + '; mv -fv ' + list + '*.txt ../txt/' + list + '; ')
    outfile = open('toc_done.txt', mode='a', encoding='UTF-8')
    outfile.write(str(list))
    outfile.close()