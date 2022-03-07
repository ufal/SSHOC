#!/bin/bash
LANG=$1
REF=$2
shift 2
HYP=$1
shift

MULTEVAL="/home/varis/tspec-workdir/multeval-0.5.1/multeval.sh"

MULTEVAL_OPTS=""
while [[ $# -gt 0 ]]; do
    MULTEVAL_OPTS="$MULTEVAL_OPTS --hyps-sys$# $1"
    shift
done

$MULTEVAL eval \
    --metrics bleu \
    --refs $REF \
    --hyps-baseline $HYP \
    --meteor.language cs \
    $MULTEVAL_OPTS
