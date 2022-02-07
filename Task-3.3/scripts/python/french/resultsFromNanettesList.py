__author__ = 'Michael Dahnke'

import re

outfile = open('../../_french/theatre-classique-Auswahl/resultsFromNanettesList.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()

infile = open('../../_french/theatre-classique-Auswahl/theatre-classique-Auswahl++.txt', encoding='UTF-8')
lists = infile.readlines()
infile.close()

for list in lists:
    list = str(re.findall('(\t[^\t]*\t)\w+\t', list, re.U))
    list = str(re.sub('\\\\t', '', list, re.U))
    list = str(re.sub('\'\, \'HTML\'', '\n', list, re.U))
    list = str(re.sub('\"\, \'HTML\'', '\n', list, re.U))
    list = str(re.sub('\]', '', list, re.U))
    list = str(re.sub('\[\'', '', list, re.U))
    list = str(re.sub('\[\"', '', list, re.U))
    list = str(re.sub('\.\n', '\n', list, re.U))
    outfile = open('../../_french/theatre-classique-Auswahl/resultsFromNanettesList.txt', mode="a", encoding='UTF-8')
    outfile.write(list)
    outfile.close()

infile = open('../../_french/theatre-classique-Auswahl/resultsFromNanettesList.txt', encoding='UTF-8')
x = infile.readlines()
infile.close()

x.sort()

x = str(x)

x = re.sub('\\\\n\'\,', '\n', x, re.U)
x = re.sub('\\\\n\'\, \"', '\n', x, re.U)
x = re.sub('\\\\n\"\, \"', '\n', x, re.U)
x = re.sub('\\\\n\"\, \'', '\n', x, re.U)
x = re.sub('\\\\n\'\, \'', '\n', x, re.U)
x = re.sub('\\\\n\'\, \'', '\n', x, re.U)
x = re.sub('\\\\n\'\, \'', '\n', x, re.U)
x = re.sub('\\\\n\'\, \'', '\n', x, re.U)
x = re.sub('\[\'', '', x, re.U)
x = re.sub('\\\\n\'\]', '', x, re.U)
x = re.sub(' \'', '', x, re.U)
x = re.sub(' \"', '', x, re.U)

outfile = open('../../_french/theatre-classique-Auswahl/resultsFromNanettesList.txt', mode='w', encoding='UTF-8')
outfile.write(str(x))
outfile.close()
