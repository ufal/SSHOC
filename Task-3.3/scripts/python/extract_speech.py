#!/usr/bin/env python3
import argparse
import re

from utils import xml2docs


def save_documents(docs, output_prefix):
    for d in docs:
        # Remove special characters and common suffixes from the file-suffix
        suffix = d
        suffix = re.sub("^#", "", suffix)
        suffix = re.sub("_AWW", "", suffix)
        # Lowercase the suffix
        suffix = suffix.lower()
        with open("{}.{}.txt".format(output_prefix, suffix), 'w') as fh:
            for line in docs[d]:
                print(line, file=fh)


def main(args):
    docs = xml2docs(args.input_file)
    save_documents(docs, args.output_prefix)


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--input-file", type=str, required=True,
        help="Location of the input TEI XML file.")
    parser.add_argument(
        "--output-prefix", type=str,
        help="Prefix of the output files.")
    return parser.parse_args()


if __name__ == '__main__':
    main(parse_args())
