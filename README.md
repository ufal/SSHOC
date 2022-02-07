# Social Sciences & Humanities Open Cloud (SSHOC) 
Scripts created and used within the SSHOC project

**General Directory Structure:**
- **scripts/python** - Python scripts used mainly for character utterance extraction and TF-IDF clustering analysis
- **scripts/bash** - TODO (scripts for...)
- **scripts/xsl** - TODO (scripts for...)

**Detailed Description (scripts/python):**

- **scripts/python/utils.py** - Library containing helper methods used by the executable scripts.
- **scripts/python/plot.py** - Library containing helper methods for cluster/dendrogram visualisation.
- **scripts/python/count_character_lines.py** - Counts the number of sentences for each unique character ID within the input TEI (.xml) file.
```
    Usage:
        $ scripts/python/count_character_lines.py --input-file <filename.xml>
        
    Options:
        --input-file - path to the input TEI-style file
```
- **scripts/python/extract_speech.py** - Extract speech/utterances (plaintext) of each unique character ID within the input TEI (.xml) file into a separate .txt file with a given <prefix>.
```
    Usage:
        $ scripts/python/extract_speech.py --input-file <filename.xml> --output-prefix <prefix>

    Options:
        --input-file - path to the input TEI-style file
        --output-prefix - prefix of the path of the output files
```
- **scripts/python/extract_speech_grouped.py** - Extract speech/utterances (plaintext) of each unique character ID within the input TEI (.xml) file into a separate .txt file with a given <prefix>. The output files are grouped into subdirectories based on the character groups defined in <groups.xml> (in a castGroup XML tag).
```
    Usage:
        $ scripts/python/extract_speech_grouped.py --input-file <filename.xml> --group-file <groups.xml> --output-dir <directory-name>
    
    Options:
        --input-file - path to the input TEI-style file
        --group-file - path to the file with character group definitions
        --output-dir - path to the output directory
```
- **scripts/python/speech_clusters.py** - Provide clustering of the characters within a <filename.xml> TEI-style drama document based on their speech/utterances represented via TF-IDF.
```
    Usage:
        $ scripts/python/speech_clusters.py --input-file <filename.xml> --language <language> --linkage <linkage-type> -n-clusters <n-clusters> --ngram-range <ngram-range> --output-prefix <prefix>
    
    Options:
        --input-file - path to the input TEI-style file
        --language - language of the text
        --linkage - linkage type for the agglomerative clustering (see https://scikit-learn.org/stable/modules/generated/sklearn.cluster.AgglomerativeClustering.html for more details)
        --n-clusters - number of output clusters
        --ngram-range - range of n-grams to be used when creating the TF-IDF representations
        --output-prefix - prefix of the path of the output files
```
- **scripts/python/speech_dendrogram.py** - Provide a hierarchical clustering of the characters within a <filename.xml> TEI-style drama document based on their speech/utterances represented via TF-IDF. The results are visualised using dendrogram.
```
    Usage:
        $ scripts/python/speech_dendrogram.py --input-file <filename.xml> --language <language> --linkage <linkage-type> --ngram-range <ngram-range> --output-prefix <prefix>

    Options:
        --input-file - path to the input TEI-style file
        --language - language of the text
        --linkage - linkage type for the agglomerative clustering (see https://scikit-learn.org/stable/modules/generated/sklearn.cluster.AgglomerativeClustering.html for more details)
        --ngram-range - range of n-grams to be used when creating the TF-IDF representations
        --output-prefix - prefix of the path of the output files


