#!/bin/sh

declare -a TASKS=(alphanli)
OLDIFS=$IFS

IFS=','

NUMOFSPLITS=10

for task in "${TASKS[@]}"; do
    rm -rf __$task.tmpdir
    rm -rf __$task-split
    mkdir -p __$task.tmpdir
    mkdir -p __$task-split
    paste -d@ ~/git/ai2/cache/$task-train-dev/train.jsonl.copy ~/git/ai2/cache/$task-train-dev/train-labels.lst.copy > __$task.tmpdir/__$task.tmp
    shuf __$task.tmpdir/__$task.tmp > __$task.tmpdir/__$task.tmp.shuf
    awk -v task="$task" -v RS='[@\n]' '{a=$0;getline b;print a > "__"task".tmpdir/__"task".train.jsonl.shuf";print b > "__"task".tmpdir/__"task".train-labels.lst.shuf"}' __$task.tmpdir/__$task.tmp.shuf
   split -n r/10 __$task.tmpdir/__$task.train.jsonl.shuf __$task-split/$task.train.jsonl.
   split -n r/10 __$task.tmpdir/__$task.train-labels.lst.shuf __$task-split/$task.train-labels.lst.
   rm -rf __$task.tmpdir
done

IFS=$OLDIFS
