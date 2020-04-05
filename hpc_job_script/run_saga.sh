#!/bin/sh

#SBATCH --account=mics
#SBATCH --partition=mics
#SBATCH --ntasks=1
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=4
#SBATCH --gpus-per-task=1
#SBATCH --mem-per-cpu=4g

source ~/.bashrc
conda activate ai2_stable

. /scratch/spack/share/spack/setup-env.sh
# When using `tensorflow-gpu`, paths to CUDA and CUDNN libraries are required
# by symbol lookup at runtime even if a GPU isn't going to be used.
spack load cuda@9.0.176
spack load cudnn@7.6.5.32-9.0-linux-x64

python eval.py \
    --input_x task_data/physicaliqa-train-dev/dev.jsonl \
    --config general.yaml \
    --checkpoint outputs/2020-03-20/16-37-40/outputs/checkpoints/_ckpt_epoch_4.ckpt \
    --input_y task_data/physicaliqa-train-dev/dev-labels.lst \
    --output pred.lst