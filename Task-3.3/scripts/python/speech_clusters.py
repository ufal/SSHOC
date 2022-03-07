#!/usr/bin/env python3
import argparse
import numpy as np

from sklearn.cluster import KMeans, AgglomerativeClustering

from utils import extract_tfidf_vectors, xml2docs
from plot import plot_clusters


def main(args):
    docs = xml2docs(args.input_file)

    ngram_range = [int(x) for x in args.ngram_range.split(",")]
    tfidf_vectors = extract_tfidf_vectors(docs, ngram_range, args.language)

    X = np.stack(tfidf_vectors.values(), 0)
    alg = AgglomerativeClustering(
        n_clusters=args.n_clusters, linkage=args.linkage).fit(X)
    labels = alg.labels_

    outfile = None
    if args.output_prefix is not None:
        outfile = "{}.clusters.{}.png".format(args.output_prefix, args.linkage)
    plot_clusters(X, labels, tfidf_vectors.keys(), outfile=outfile)

    outfile = None
    if args.output_prefix is not None:
        outfile = open("{}.clusters.{}.txt".format(args.output_prefix, args.linkage), "w")
    for name, lab in zip(tfidf_vectors.keys(), labels):
        print("{}\t{}".format(name, lab), file=outfile)


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--input-file", type=str, required=True,
        help="Location of the input TEI XML file.")
    parser.add_argument(
        "--language", type=str, default="english",
        help="Input language.")
    parser.add_argument(
        "--linkage", type=str, default="complete",
        help="Linkage type for agglomerative clustering algorithm.")
    parser.add_argument(
        "--n-clusters", type=int, default=10,
        help="Number of clusters.")
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
