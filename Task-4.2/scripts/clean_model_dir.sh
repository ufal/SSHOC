#!/bin/bash
# Remove the binarized training files after model training
set -e

MODEL_DIR=$1
[[ -d $MODEL_DIR ]] || exit 1

rm $MODEL_DIR/data/translate_encs_wmt_czeng57m32k-train* 2> /dev/null || rm $MODEL_DIR/data/translate32k-train* 2> /dev/null
