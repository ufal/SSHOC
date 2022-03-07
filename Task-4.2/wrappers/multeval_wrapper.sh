#!/bin/bash
set -e

WD=`dirname "$(readlink -f "$0")"`  # location of the script
MULTEVAL="$WD/../multeval/multeval.sh"

LANG=$1
REF=$2
shift 2
HYP=$1
shift

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
