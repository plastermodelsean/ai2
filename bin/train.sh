#!/bin/sh
PYTHON=/auto/nlg-05/wangli/miniconda3/envs/ai2_chenghao/bin/python
TRAIN=/auto/rcf-40/wangli/project/ai2_chenghao/train.py

$PYTHON -W ignore $TRAIN --model_type $1 --model_weight $2 \
  --task_config_file config/tasks.yaml \
  --running_config_file config/hyparams.yaml \
  --task_name $3 \
  --task_cache_dir ./cache \
  --output_dir output/$1-$2-$3-pred \
  --log_save_interval 25 --row_log_interval 25
