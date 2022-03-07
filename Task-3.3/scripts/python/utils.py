# TODO: method argument signatures
import glob
import re
import xml.etree.ElementTree as ET

from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize

from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer


def xml2charlist(filename):
    """Extract the list of characters from the input TEI file."""

    root = ET.parse(filename).getroot()
    res = set()

    ns = re.match(r'{.*}', root.tag).group(0)
    for e in root.iter('{}person'.format(ns)):
        namespace = "{http://www.w3.org/XML/1998/namespace}"

        val = e.attrib["{}id".format(namespace)]
        res.add(val)

    return res


def xml_get_title(filename):
    root = ET.parse(filename).getroot()
    res = {}

    ns = re.match(r'{.*}', root.tag).group(0)
    for e in root.iter('{}title'.format(ns)):
        # We only need the first instance
        return e.text


def xml_extract_groups(filename, target_title):
    root = ET.parse(filename).getroot()
    res = {}

    ns = re.match(r'{.*}', root.tag).group(0)
    for e in root.iter('{}castGroup'.format(ns)):
        title = [t.text for t in e.iter('{}ref'.format(ns))]
        if not title:
            continue

        assert len(title) == 1
        title = title[0]

        if title == target_title:
            for group in e.iter('{}castGroup'.format(ns)):
                # .iter also iterates over the element itself, which is castGroup
                if group == e:
                    continue
                group_elements = []
                group_name = [name.text for name in group.iter('{}head'.format(ns))]

                assert len(group_name) == 1
                group_name = group_name[0]

                for name in group.iter('{}castItem'.format(ns)):
                    name = [v for v in name.attrib.values()]

                    if not name:
                        continue
                    assert len(name) == 1
                    name = name[0]
                    name = '#{}'.format(name)  # we add '#' to the beginning for compatibility with naming in the play TEI documents

                    group_elements.append(name)
                res[group_name] = group_elements
    return res            


def xml2docs(filename):
    """Process the input TEI file.

    In this context, a ``document'' is a set of sentences spoken
    by a single character.
    """
    root = ET.parse(filename).getroot()
    res = {}

    ns = re.match(r'{.*}', root.tag).group(0)
    for e in root.iter('{}sp'.format(ns)):
        if 'who' in e.attrib:
            who_all = e.attrib['who'].split(" ")
        else:
            continue
        for who in who_all:
            if who not in res:
                res[who] = []

        lines = []
        for e_ch in e.iter('{}l'.format(ns)):
            line = " ".join([
                "".join(w.itertext()) for w in e_ch.iter('{}w'.format(ns))
            ])
            if not line:
                line = e_ch.text
            lines.append(line)
        if not lines:
            for p in e.iter('{}p'.format(ns)):
                line = " ".join([
                    "".join(w.itertext()) for w in p.iter('{}w'.format(ns))
                ])
                if not line:
                    line = " ".join([
                        "".join(s.itertext()) for s in p.iter('{}s'.format(ns))
                    ])
                lines.append(line)
        for who in who_all:
            res[who] += lines
    return res


def dir2docs(dirname):
    """Process the input directory containing plaintext files, one per each ``document''.

    """
    res = {}

    for f in glob.glob('{}/*.txt'.format(dirname)):
        doc = []
        with open(f, "r") as fh:
            for line in fh:
                line = line.strip()
                doc.append(line)
        name = f.split("/")[-1][:-4]  # strip the fullpath and the '.txt' suffix fromt the filename
        res[name] = doc

    return res


def extract_tfidf_vectors(docs, ngram_range=[1, 1], language="english"):
    assert len(ngram_range) == 2

    # A document is a list of sentences...
    for k, v in docs.items():
        docs[k] = " ".join(v)

    ps = PorterStemmer()
    keys = docs.keys()

    tfidf_vectors = TfidfVectorizer(
        tokenizer=word_tokenize,
        preprocessor=ps.stem,
        lowercase=True,
        stop_words=set(stopwords.words(language)),
        ngram_range=ngram_range,
        ).fit_transform(docs.values()).todense()

    return {k: v for k, v in zip(keys, tfidf_vectors)}


def extract_count_vectors(docs, ngrams=1, language="english"):
    assert ngrams > 0
    
    # A document is a list of sentences...
    for k, v in docs.items():
        docs[k] = " ".join(v)

    ps = PorterStemmer()
    keys = docs.keys()

    vectorizer = CountVectorizer(
        tokenizer=word_tokenize,
        preprocessor=ps.stem,
        lowercase=True,
        stop_words=set(stopwords.words(language)),
        ngram_range=[ngrams, ngrams],
    ).fit(docs.values())

    tokens = vectorizer.get_feature_names()

    return {
        key : {
            k : v for k, v in zip(tokens, vectorizer.transform([docs[key]]).toarray()[0])
        } for key in docs
    }
