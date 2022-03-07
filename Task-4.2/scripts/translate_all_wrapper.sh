#!/bin/bash
MODEL=${1:-"baseline"}
LANGUAGES=${2:-"cs,de,fr,pl,ru"}
TESTSET=${3:-"test"}

MODEL_DIR="$HOME/tspec-workdir/t2t-lindat/output/system_aliases"
INPUT_DIR="$HOME/tspec-workdir/t2t-lindat/data/sshoc-mcsq-surveys"
OUTPUT_DIR="$HOME/tspec-workdir/t2t-lindat/translation_output"
OVERWRITE=1


LANGUAGES=`echo $LANGUAGES | tr "," " "`


function translate {
    _model=$1
    _input=$2
    _output=$3

    jid=`qsubmit \
        --logdir=logs \
        --jobname=sshoc_translate_en$l \
        --gpus=1 \
        --mem=15g \
        --gpumem=11g "scripts/translate.sh -i $_input -o $_output -m $_model"`
    jid=`echo $jid | cut -d" " -f3`
    echo $jid
}


# Translate untranslated data
job_ids=""
for l in $LANGUAGES; do
    infile="$INPUT_DIR/$TESTSET.en-$l.$l"
    outfile="$OUTPUT_DIR/$MODEL.$TESTSET.en-$l.en"
    if [[ ! -e $outfile ]] || [[ $OVERWRITE -eq 1 ]]; then
        job_ids="$job_ids $(translate $MODEL_DIR/$MODEL.${l}-en $infile $outfile)"
    fi
    sleep 1

    infile="$INPUT_DIR/$TESTSET.en-$l.en"
    outfile="$OUTPUT_DIR/$MODEL.$TESTSET.en-$l.$l"
    if [[ ! -e $outfile ]] || [[ $OVERWRITE -eq 1 ]]; then
        job_ids="$job_ids $(translate $MODEL_DIR/$MODEL.en-${l} $infile $outfile)"
    fi
    sleep 1
done
echo "Processing $job_ids"
