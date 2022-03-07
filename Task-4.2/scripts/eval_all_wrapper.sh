#!/bin/bash
MODELS=${1:-"baseline"}
LANGUAGES=${2:-"cs,de,fr,pl,ru"}
TESTSET=${3:-"test"}

MODEL_DIR="$HOME/tspec-workdir/t2t-lindat/output/system_aliases"
INPUT_DIR="$HOME/tspec-workdir/t2t-lindat/data/sshoc-mcsq-surveys"
OUTPUT_DIR="$HOME/tspec-workdir/t2t-lindat/translation_output"

LANGUAGES=`echo $LANGUAGES | tr "," " "`
MODELS=`echo $MODELS | tr "," " "`

MULTEVAL_WRAPPER="$HOME/tspec-workdir/t2t-lindat/scripts/multeval_wrapper"


for l in $LANGUAGES; do
    reference="$INPUT_DIR/$TESTSET.en-$l.$l"
    hypotheses=""
    for model in $MODELS; do
        hypotheses="$hypotheses $OUTPUT_DIR/$model.$TESTSET.en-$l.$l"
    done
    $MULTEVAL_WRAPPER $l $reference $hypotheses

    reference="$INPUT_DIR/$TESTSET.en-$l.en"
    hypotheses=""
    for model in $MODELS; do
        hypotheses="$hypotheses $OUTPUT_DIR/$model.$TESTSET.en-$l.en"
    done
    $MULTEVAL_WRAPPER en $reference $hypotheses
done
