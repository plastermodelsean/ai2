#!/bin/bash
#SBATCH --ntasks=1                      # Number of instances launched of this job.
#SBATCH --time=01-00:00:00                  # The time allocated for this job. Default is 30 minsutes. Acceptable format: MM, MM:SS, HH:MM:SS, DD-HH", DD-HH:MM, DD-HH:MM:SS.
#SBATCH --partition=isi                 # The partition of HPC of this job. Remove this line if you don't want to specify a partition
#SBATCH --mem=30G                        # Total memory allocated (single core)
#SBATCH --gres=gpu:k80:4                # Number of GPU cores needed. Format is gpu:<GPU_type>:<number>. <GPU_type> is one of the following: k20, k40, k80, or p100.
#SBATCH --job-name=ROBERTA_INCREMENTAL             # The name of this job. If removed the job will have name of your shell script.
#SBATCH --output=%x-%j.out              # The name of the file output. %x-%j means JOB_NAME-JOB_ID. If removed output will be in file slurm-JOB_ID.
#SBATCH --mail-user=dwangli@isi.edu       # Email address for email notifications to be sent to.
#SBATCH --mail-type=ALL                 # Type of notifications to receive. Other options includes BEGIN, END, FAIL, REQUEUE and more.
#SBATCH --export=NONE                   # Ensure job gets a fresh login environment
#SBATCH --array=0-11%1                     # Submitting an array of (n-m+1) jobs, with $SLURM_ARRAY_TASK_ID ranging from n to m. Add %1 if you only want one jobs running at one time.

### Load the python version of your choosing (Here we load python 3.7.4)
SOURCE_DIR=$(pwd)
echo ""

### Change to staging directory for fast read/write, output some system variables for monitoring
echo "Current working directory: $(pwd)"
echo "Starting run at: $(date)"
echo "Job Array ID / Job ID: $SLURM_ARRAY_JOB_ID / $SLURM_JOB_ID"
echo "This is job $SLURM_ARRAY_TASK_ID out of $SLURM_ARRAY_TASK_COUNT jobs."

# Create a total array of models and tasks and permute them
allPercentage=(0 2 5 7 10 15 20 25 30 50 70 100)
modelPercentage=${allPercentage[${SLURM_ARRAY_TASK_ID}]}

echo ""
echo "This is for percentage"
echo "$modelPercentage"
bash /auto/nlg-05/wangli/ai2/bin/train.sh roberta roberta-large alphanli_"$modelPercentage"
echo ""
echo "Training finished, starting evaluating"
echo ""
bash /auto/nlg-05/wangli/ai2/bin/eval.sh roberta roberta-large alphanli_"$modelPercentage"
echo ""

### Finishing up the job and copy the output off of staging
echo "Job finished with exit code $? at: $(date)"
