#!/bin/sh

PYTHON=/auto/nlg-05/wangli/miniconda3/envs/ai2/bin/python
EVAL=/auto/rcf-40/wangli/project/ai2/eval.py
OUTPUT=/auto/rcf-40/wangli/project/ai2/output

FILE=$OUTPUT/$1-$2-checkpoints/$3/0/_ckpt_epoch_6.ckpt
if [ ! -f "$FILE" ]; then
  FILE=$OUTPUT/$1-$2-checkpoints/$3/0/_ckpt_epoch_5.ckpt
  if [ ! -f "$FILE" ]; then
    FILE=$OUTPUT/$1-$2-checkpoints/$3/0/_ckpt_epoch_3.ckpt
    if [ ! -f "$FILE" ]; then
      FILE=$OUTPUT/$1-$2-checkpoints/$3/0/_ckpt_epoch_2.ckpt
      if [ ! -f "$FILE" ]; then
        FILE=$OUTPUT/$1-$2-checkpoints/$3/0/_ckpt_epoch_1.ckpt
      fi
    fi
  fi
fi

$PYTHON -W ignore $EVAL --model_type "$1" \
  --model_weight "$2" \
  --task_name "$3" \
  --task_config_file config/tasks.yaml \
  --task_cache_dir ./cache \
  --running_config_file config/hyparams.yaml \
  --output_dir $OUTPUT/"$1"-"$2"-"$3"-pred \
  --weights_path "$FILE" \
  --tags_csv $OUTPUT/"$1"-"$2"-log/"$3"/version_0/meta_tags.csv
