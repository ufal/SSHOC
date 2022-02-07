__author__ = 'michaeldahnke'

import re

infile = open ('clustersForShakespearianDramas.xml', encoding='UTF-8')
data = infile.read()
infile.close()

data = re.sub('corresp="\#.*" ', '', data)
data = re.sub('corresp="\#.*"/', '/', data)
data = re.sub('corresp=".*"', '/', data)
data = re.sub('sameAs=\"#', 'xml:id=\"', data)
data = re.sub('" />', '"/>', data)


##  data = re.sub('\n', '"; ', data)

outfile = open("clustersForShakespearianDramas.xml", mode="w", encoding='UTF-8')
outfile.write(data)
outfile.close()
