__author__ = 'michaeldahnke'

import re

headTagsNew = []
c = 0

outfile = open('listAndNumberOfCategoriesForDramaCharactersInShakespearePieces.txt', mode='w', encoding='UTF-8')
outfile.write('CATEGORIES:\n\n')
outfile.close()

infile = open('clustersForShakespearianDramas.xml', encoding='UTF-8')
text = infile.read()
infile.close()

headTags = re.findall('<head>.*</head>?', text)
headTags = set(headTags)
headTags = list(headTags)
headTags.sort(reverse = False)

for headTag in headTags:
    if not '<ref target="https://www.playshakespeare.com/' in headTag:
        c += 1
        headTag = re.sub('<head>', '', headTag, re.U)
        headTag = re.sub('</head>', '', headTag, re.U)
        outfile = open('listAndNumberOfCategoriesForDramaCharactersInShakespearePieces.txt', mode='a', encoding='UTF-8')
        outfile.write('\t' + headTag + '\n')
        outfile.close()

print(c)

outfile = open('listAndNumberOfCategoriesForDramaCharactersInShakespearePieces.txt', mode='a', encoding='UTF-8')
outfile.write('\nNumber of categories: ' + str(c))
outfile.close()

# II. PREPROCESSING IT FOR FURTHER WORK WITH XSLT SCRIPT

# for headTag in headTags:
#     if not '<ref target="https://www.playshakespeare.com/' in headTag:
#         outfile = open('listAndNumberOfCategoriesForDramaCharactersInShakespearePieces.txt', mode='a', encoding='UTF-8')
#         outfile.write(headTag + '\n')
#         outfile.close()

# outfile = open('listAndNumberOfCategoriesForDramaCharactersInShakespearePieces.txt', mode='a', encoding='UTF-8')
# outfile.write('</heads>\n')
# outfile.close()

