import os,glob,re

__author__ = 'michaeldahnke'

## Open external file in which respective xml code shall be stored and erase possible already existing content.
outfile = open('canon60Individuals.xml', mode="w", encoding='UTF-8')

## Writin' all the XML code into final xml above stuff comes into from the other files.
outfile.write('<?xml version="1.0" encoding="UTF-8"?>' + '\n' + '<?xml-model type="application/xml" href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_drama.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>' + '\n' + '<?xml-model type="application/xml" href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_drama.rng" schematypens="http://purl.oclc.org/dsdl/schematron"?>' + '\n' + '<TEI xmlns="http://www.tei-c.org/ns/1.0">' + '\n' + '<teiHeader>' + '\n' + '<fileDesc>' + '\n' + '<titleStmt>' + '\n' + '<title>Canon60 TOC</title>' + '\n' + '</titleStmt>' + '\n' + '<publicationStmt>' + '\n' + '<p>Publication Information</p>' + '\n' + '</publicationStmt>' + '\n' + '<sourceDesc>' + '\n' + '<listBibl n="canon60Individuals">')

## Goes to respective directory with xml files inside and assign content to variable ›folder_path‹.
folder_path = 'individuals'

## Create a counter var. which is needed assigning number to every bibliographical entry in final xml catalogue.
c = 0

## Read content of each file, 1 after the other.
for filename in glob.glob(os.path.join(folder_path, '*.xml')):
  with open(filename, 'r') as f:

## Assinging pathname + complete content of first file to var. ›text‹.
    text = f.read()

## Counter counting consecutively for each entry.
    c += 1

## Replacing some stuff within var. ›filename‹ and re-assisigning.
    filename = str(filename.replace('individuals/', '', re.U))
    filename = str(filename.replace('.xml', '', re.U))

## Seek within' string ›text‹ substring as described and assigning content of that substring to var. ›author‹.
    author = str(re.findall('<h2 id="autor">'r'\D*\D'"</h2>", text, re.U))

## Seek within' string ›text‹ substring as described and assigning content of that substring to var. ›anonymus‹.
    anonymus = str(re.findall('<h2 id="autor"></h2>', text, re.U))

## Replacing some stuff within var. ›author‹ and re-assisigning.
    author = str(author.replace('\\n', ' ', re.U))
    author = str(author.replace('\\t', ' ', re.U))
    author = str(author.replace('ó', 'o', re.U))
    author = str(author.replace('é', 'e', re.U))
    author = str(author.replace('í', 'i', re.U))
    author = str(author.replace('á', 'a', re.U))

## Substitute some stuff within var. ›author‹ and re-assisigning.
    author = re.sub('>\s+', '>', author)
    author = re.sub('\s+<', '<', author)

## Substitute some stuff within var. ›anonymus‹ and re-assisigning.
    anonymus = re.sub('>\s+', '>', anonymus)
    anonymus = re.sub('\s+<', '<', anonymus)

## Following substitutes all elements for author to wished XML format.
    if 'Calderon' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="cald">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Calderón de la Barca</name>' + '\n' + '<name type="forename">Pedro</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Moreto' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="more">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Moreto</name>' + '\n' + '<name type="forename">Agustín</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Lope' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="lope">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Vega Carpío</name>' + '\n' + '<name type="forename">Lope Felix de</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Solis' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="soli">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">de Solís</name>' + '\n' + '<name type="forename">Antonio</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Rojas' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="roja">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Rojas Zorrilla</name>' + '\n' + '<name type="forename">Francisco de</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Guille' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="cast">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">de Castro</name>' + '\n' + '<name type="forename">Guillén</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Cervantes' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="cerv">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Cervantes Saavedra</name>' + '\n' + '<name type="forename">Miguel de</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Molina' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="moli">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Molina</name>' + '\n' + '<name type="forename">Tirso de</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Guevara' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="vele">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Vélez de Guevara</name>' + '\n' + '<name type="forename">Luis</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Virues' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="viru">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Virués</name>' + '\n' + '<name type="forename">Cristóbal de</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Godinez' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="godi">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Godínez</name>' + '\n' + '<name type="forename">Felipe</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Amescua' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="ames">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Mira de Amescua</name>' + '\n' + '<name type="forename">Antonio</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Aragon' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="cubi">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Cubillo de Aragón</name>' + '\n' + '<name type="forename">Álvaro</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Aguilar' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="agui">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Aguilar</name>' + '\n' + '<name type="forename">Gaspar</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Zayas' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="zaya">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Zayas y Sotomayor</name>' + '\n' + '<name type="forename">María de</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Artieda' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="reyd">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Rey de Artieda</name>' + '\n' + '<name type="forename">Andrés</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Monteser' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="mont">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Monteser</name>' + '\n' + '<name type="forename">Francisco Antonio de</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Tarrega' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="tarr">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Tárrega</name>' + '\n' + '<name type="forename">Francisco</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Juana' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="juan">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Juana Inés de la Cruz</name>' + '\n' + '<name type="forename">Sor</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Ruiz' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="ruiz">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Ruiz de Alarcón y Mendoza</name>' + '\n' + '<name type="forename">Juan</name>' + '\n' + '</name>' + '\n' + '</author>'
    if 'Coello' in author:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="coel">' + '\n' + '<name type="fullName">' + '\n' + '<name type="surname">Coello</name>' + '\n' + '<name type="forename">Antonio</name>' + '\n' + '</name>' + '\n' + '</author>'
    if '<h2 id="autor"></h2>' in anonymus:
      author = '<bibl n="' + str(c) + '" xml:id="' + str(filename) + '">' + '\n' + '<author key="anon">' + '\n' + '<name type="fullName">Anonymus</name>' + '\n' + '</author>'

## Seeking within string ›text‹ substring as described and assigning content of that substring to var. ›title‹.
    title = str(re.findall('<h1 id="titPrincipal">'r'\D*\D'"</h1>", text, re.U))

## Replacing some stuff within var. ›title‹ and re-assisigning.
    title = str(title.replace('\\n', ' ', re.U))
    title = str(title.replace('\\t', ' ', re.U))

## Substitute some stuff within var. ›title‹ and re-assisigning.
    title = re.sub('>\s+', '>', title)
    title = re.sub('\s+<', '<', title)
    title = re.sub('<h1 id="titPrincipal">', '<title n="' + str(c) + '">', title)
    title = re.sub('</h1>', '</title>' + '\n' + '</bibl>', title)
    title = re.sub('\[\'', '', title)
    title = re.sub('\'\]', '', title)

## Opening file for storing content into it.
    outfile = open('canon60Individuals.xml', mode="a", encoding='UTF-8')

## Storing content in the file.
    outfile.write(author + '\n' + title + '\n')

## Writin' all the XML code into final xml below stuff come into from external text files.
outfile.write('\n' + '</listBibl>' + '\n' + '</sourceDesc>' + '\n' + '</fileDesc>' + '\n' + '</teiHeader>' + '\n' + '<text>' + '\n' + '<body>' + '\n' + '<p></p>' + '\n' + '</body>' + '\n' + '</text>' + '\n' + '</TEI>')

## Close file.  
outfile.close()

infile = open ('canon60Individuals.xml', encoding='UTF-8')
data = infile.read()
infile.close()

data = re.sub('\\n\\n', '', data)

outfile = open ('canon60Individuals.xml', mode='w', encoding='UTF-8')
outfile.write(str(data))
outfile.close()
