#!/bin/bash
set -e

WD=`dirname "$(readlink -f "$0")"`  # location of the script
T2T_BIN="$WD/../tensor2tensor-1.6.6/tensor2tensor/bin"

# Default parameter values
INPUT_FILE="/dev/stdin"
OUTPUT_FILE="/dev/stdout"

BEAM_SIZE=4
ALPHA=1.0
N_CHECKPOINTS=8

MODEL_ROOT=

PROBLEM="translate_encs_wmt_czeng57m32k"
MODEL="transformer"
HPARAMS_SET="transformer_big_single_gpu"
HPARAMS=


print_usage () {
    echo ""
    echo "      Usage:"
    echo "          $0 -i INPUT_FILE -o OUTPUT_FILE -m MODEL_DIR [OPTION]"
    echo ""
    echo "      -i, --input FILE"
    echo "          input file (default=$INPUT_FILE)"
    echo "      -o, --output FILE"
    echo "          output file (default=$OUTPUT_FILE)"
    echo "      -m, --model-dir PATH"
    echo "          model directory (output of prepare_data.sh)"
    echo "      -a, --alpha NUM"
    echo "          beamsearch length penalty (default=$ALPHA)"
    echo "      -b, --beam-size INT"
    echo "          beam size (default=$BEAM_SIZE)"
    echo "      -p, --problem STRING"
    echo "          problem name (default=$PROBLEM)"
    echo "      --hparams STRING"
    echo "          additional tensor2tensor model parameters"
    echo "      -n, --n-checkpoints INT"
    echo "          average last N checkpoints (default=$N_CHECKPOINTS)"
    echo ""
    exit 1
}

# Parsing parameters
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -i|--input)
            INPUT_FILE="$2"
            shift
        ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift
        ;;
        -m|--model-dir)
            MODEL_ROOT="$2"
            shift
        ;;
        -b|--beam-size)
            BEAM_SIZE="$2"
            shift
        ;;
        -a|--alpha)
            ALPHA="$2"
            shift
        ;;
        -p|--problem)
            PROBLEM="$2"
            shift
        ;;
        --hparams)
            HPARAMS="$2"
            shift
        ;;
        -n|--n-checkpoints)
            N_CHECKPOINTS="$2"
            shift
        ;;
        *)
            echo Unknown option '"'$key'"' >&2
            exit 1
        ;;
    esac
    shift
done

# Testing (required) parameter values
[[ -n "$MODEL_ROOT" ]] && [[ -d "$MODEL_ROOT" ]] || print_usage

#Setting up directories
DATA_DIR=$MODEL_ROOT/data
TMP_DIR=$MODEL_ROOT/tmp_dir
USER_DIR=$MODEL_ROOT/user_dir
MODEL_DIR=$MODEL_ROOT/model

export PYTHONUNBUFFERED=yes
export PYTHONPATH="$WD/../tensor2tensor-1.6.6":$PYTHONPATH

# (Optional) Checkpoint averaging
if [[ $N_CHECKPOINTS -gt 1 ]]; then
    mkdir -p $MODEL_DIR/averaged
    $T2T_BIN/t2t-avg-all \
        --model_dir=$MODEL_DIR \
        --output_dir=$MODEL_DIR/averaged \
        --n=$N_CHECKPOINTS \
        --wait_minutes=1
    pid_avg=$!
    MODEL_DIR=$MODEL_DIR/averaged

    sleep 30s

    # Wait for the averaging to finish
    while true; do ps -p "$pid_avg" > /dev/null 2>&1 || break; sleep 1m; done
fi

# Running inference
echo "Running: $T2T_BIN/t2t-decoder --t2t_usr_dir=$USER_DIR --data_dir=$DATA_DIR --problem=$PROBLEM --model=$MODEL --hparams_set=$HPARAMS_SET --hparams=$HPARAMS --output_dir=$MODEL_DIR --decode_hparams=\"beam_size=$BEAM_SIZE,alpha=$ALPHA,write_beam_scores=False,return_beams=False\" --decode_from_file=$INPUT_FILE --decode_to_file=$OUTPUT_FILE"
$T2T_BIN/t2t-decoder \
	--t2t_usr_dir=$USER_DIR \
	--data_dir=$DATA_DIR \
    --problem=$PROBLEM \
	--model=$MODEL \
	--hparams_set=$HPARAMS_SET \
    --hparams=$HPARAMS \
	--output_dir=$MODEL_DIR \
	--decode_hparams="beam_size=$BEAM_SIZE,alpha=$ALPHA,write_beam_scores=False,return_beams=False" \
	--decode_from_file=$INPUT_FILE \
    --decode_to_file=$OUTPUT_FILE
