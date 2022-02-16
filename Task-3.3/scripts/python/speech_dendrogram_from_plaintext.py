#!/usr/bin/env python3
import argparse
import numpy as np

from scipy.cluster import hierarchy

from utils import dir2docs, extract_tfidf_vectors, xml2docs
from plot import plot_dendrogram


def main(args):
    docs = dir2docs(args.input_dir)

    ngram_range = [int(x) for x in args.ngram_range.split(",")]
    tfidf_vectors = extract_tfidf_vectors(docs, ngram_range, args.language)

    X = np.stack(tfidf_vectors.values(), 0)
    clusters = hierarchy.linkage(X, method=args.linkage)

    outfile = None
    if args.output_prefix is not None:
        outfile = "{}.dendrogram.{}.png".format(args.output_prefix, args.linkage)
    plot_dendrogram(clusters, list(tfidf_vectors.keys()), outfile=outfile)


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--input-dir", type=str, required=True,
        help="Location of the input TEI XML file.")
    parser.add_argument(
        "--language", type=str, default="english",
        help="Input language.")
    parser.add_argument(
        "--linkage", type=str, default="complete",
        help="Type of clustering linkage.")
    parser.add_argument(
        "--ngram-range", type=str, default="1,1",
        help="Min-max n-grams for tf-idf vectorizer.")
    parser.add_argument(
        "--output-prefix", type=str, default=None,
        help="Prefix of the output files. If empty, the script will "
            "use standard output instead.")
    return parser.parse_args()


if __name__ == '__main__':
    main(parse_args())
