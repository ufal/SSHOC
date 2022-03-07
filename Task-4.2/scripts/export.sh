#!/bin/bash
set -e

OUTPUT_PATH=$1

BEAM_SIZE=${2:-4}
ALPHA=${3:-0.6}

CUSTOM_OPTS=${4:-""}

source /home/varis/python-virtualenv/tensorflow-1.12-cpu/bin/activate
export PYTHONPATH=`pwd`/tensor2tensor-1.6.6/:$PYTHONPATH
tensor2tensor-1.6.6/tensor2tensor/bin/t2t-exporter \
	--t2t_usr_dir=$OUTPUT_PATH/user_dir \
	--data_dir=$OUTPUT_PATH/data \
	--model=transformer \
	--hparams_set=transformer_big_single_gpu \
	--output_dir=$OUTPUT_PATH/model \
	--problem=translate_encs_wmt_czeng57m32k \
	--decode_hparams="beam_size=$BEAM_SIZE,alpha=$ALPHA,write_beam_scores=False,return_beams=False" \
    --hparams="num_encoder_layers=12"
