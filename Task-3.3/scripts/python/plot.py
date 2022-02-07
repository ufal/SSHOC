# TODO: argument signatures
import numpy as np

from itertools import cycle, islice
from scipy.cluster import hierarchy
from sklearn.decomposition import PCA

import matplotlib.pyplot as plt


def plot_dendrogram(clusters, names, outfile=None):
    plt.figure(figsize=(6,6))
    plt.rcParams['figure.autolayout'] = True
    fig, ax = plt.subplots()
    dendrogram = hierarchy.dendrogram(
        clusters,
        labels=names,
        orientation="right",
        distance_sort="descending",
        leaf_font_size=9
    )
    plt.xlabel('Euclidean Distance');

    if outfile is not None:
        plt.savefig(outfile)
    plt.show()


def plot_clusters(X, labels, annotations=None, outfile=None):
    X = PCA(n_components=2, svd_solver="full").fit_transform(X)

    fig, ax = plt.subplots()
    colors = np.array(list(islice(cycle(['#377eb8', '#ff7f00', '#4daf4a',
                                         '#f781bf', '#a65628', '#984ea3',
                                         '#999999', '#e41a1c', '#dede00']),
                                  int(max(labels) + 1))))
    unique_labels = set(labels)

    for i, lab in enumerate(unique_labels):
        lab_idx = np.where(labels == lab)
        ax.scatter(X[lab_idx, 0], X[lab_idx, 1], s=10, color=colors[lab], label=lab)
    ax.legend()

    plt.xlim(-0.7, 0.7)
    plt.ylim(-0.7, 0.7)
    plt.xticks(())
    plt.yticks(())

    if outfile is not None:
        plt.savefig(outfile)
    plt.show()
