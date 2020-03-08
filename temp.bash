#!/bin/bash

TASK=alphanli
TASK_DIR=./cache/alphanli-train-dev
TRAIN_FILE=$TASK_DIR/train.jsonl
TRAIN_LABEL_FILE=$TASK_DIR/train-labels.lst
SPLIT_RESULT_DIR=$TASK_DIR/increment_training
SEED=0
SPLIT_PERCENTAGES=(0 2 5 7 10 15 20 25 30 50 70 100)

get_seeded_random()
{
    seed="$1";
    openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
        </dev/zero 2>/dev/null;
}

rm -rf "$SPLIT_RESULT_DIR"
mkdir -p "$SPLIT_RESULT_DIR"
for PERCENTAGE in "${SPLIT_PERCENTAGES[@]}"; do
  OUTPUT_DIR="${SPLIT_RESULT_DIR:?}"/"${PERCENTAGE}"
  rm -rf "$OUTPUT_DIR"
  mkdir -p "$OUTPUT_DIR"
  paste -d"$(printf '\t')" $TRAIN_FILE $TRAIN_LABEL_FILE > "$OUTPUT_DIR"/train_w_label.lst
  shuf --random-source=<(get_seeded_random $SEED) "$OUTPUT_DIR"/train_w_label.lst > "$OUTPUT_DIR"/train_w_label.shuf
  python temp.py "$PERCENTAGE" "$OUTPUT_DIR" "$TASK"
  rm "$OUTPUT_DIR"/train_w_label.lst
  rm "$OUTPUT_DIR"/train_w_label.shuf
  echo "Finished for percentage $PERCENTAGE"
done
