#!/bin/bash
set -e

WD=`dirname "$(readlink -f "$0")"`  # location of the script
T2T_BIN="$WD/../tensor2tensor-1.6.6/tensor2tensor/bin"

# Default parameter values
MODEL_ROOT=
BEAM_SIZE=4
ALPHA=0.6
CUSTOM_OPTS=""

PROBLEM="translate_encs_wmt_czeng57m32k"
MODEL="transformer"
HPARAMS_SET="transformer_big_single_gpu"

print_usage () {
    echo ""
    echo "      Usage:"
    echo "      $0 -m MODEL_DIR --[OPTION]"
    echo ""
    echo "      -m, model-dir PATH"
    echo "          model directory (output of prepare_data.sh)"
    echo "      -a, --alpha NUM"
    echo "          beamsearch length penalty (default=$ALPHA)"
    echo "      -b, --beam-size"
    echo "          beam size (default=$BEAM_SIZE)"
    echo "      -p, --problem STRING"
    echo "          problem name (default=$PROBLEM)"
    echo "      --opts STRING"
    echo "          additional options"
    echo ""
    exit 1
}


# Parsing parameters
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -m|--model-dir)
            MODEL_ROOT="$2"
            shift
        ;;
        -a|--alpha)
            ALPHA="$2"
            shift
        ;;
        -b|--beam-size)
            BEAM_SIZE="$2"
            shift
        ;;
        --opts)
            CUSTOM_OPTS="$2"
            shift
        ;;
        *)
            echo Unknown option '"'$key'"' >&2
            exit 1
        ;;
    esac
    shift
done


# Testing (required) parameters values
if [[ ! -d $MODEL_ROOT ]]; then
    print_usage
fi

export PYTHONUNBUFFERED=yes
export PYTHONPATH="$WD/../tensor2tensor-1.6.6/:$PYTHONPATH"

$T2T_BIN/t2t-exporter \
	--t2t_usr_dir=$MODEL_ROOT/user_dir \
	--data_dir=$MODEL_ROOT/data \
	--model=$MODEL \
	--hparams_set=$HPARAMS_SET \
	--output_dir=$MODEL_ROOT/model \
	--problem=$PROBLEM \
	--decode_hparams="beam_size=$BEAM_SIZE,alpha=$ALPHA,write_beam_scores=False,return_beams=False"
