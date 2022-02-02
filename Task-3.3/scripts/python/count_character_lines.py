#!/usr/bin/env python3
import argparse
import re

from utils import xml2docs, xml2charlist


def main(args):
    charlist = xml2charlist(args.input_file)
    docs = xml2docs(args.input_file)

    for ch in charlist:
        ch = "#" + ch
        lines = 0
        if ch in docs:
            lines = len(docs[ch])

        print("{}\t{}".format(ch, lines))


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--input-file", type=str, required=True,
        help="Location of the input TEI XML file.")
    return parser.parse_args()


if __name__ == '__main__':
    main(parse_args())
