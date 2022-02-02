#!/usr/bin/env python3
import argparse
import os
import re

from utils import xml2docs, xml_get_title, xml_extract_groups


def save_documents(docs, output_dir):
    for d in docs:
        # Remove special characters and common suffixes from the file-suffix
        fname = d
        fname = re.sub("^#", "", fname)
        fname = re.sub("_AWW", "", fname)
        # Lowercase the suffix
        fname = fname.lower()
        with open("{}/{}.txt".format(output_dir, fname), 'w') as fh:
            for line in docs[d]:
                print(line, file=fh)


def main(args):
    docs = xml2docs(args.input_file)

    title = xml_get_title(args.input_file)
    groups = xml_extract_groups(args.group_file, title)
    for g in groups:
        os.mkdir('{}/{}'.format(args.output_dir, g))
        docs_subgroup = {
            d: docs[d]
            for d in docs if d in groups[g]
        }
        save_documents(docs_subgroup, '{}/{}'.format(args.output_dir, g))


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--input-file", type=str, required=True,
        help="Location of the input TEI XML file.")
    parser.add_argument(
        "--group-file", type=str, required=True,
        help="Location of the file containing group definitions.")
    parser.add_argument(
        "--output-dir", type=str,
        help="Location of the output directory.")
    return parser.parse_args()


if __name__ == '__main__':
    main(parse_args())
