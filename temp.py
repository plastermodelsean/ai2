import argparse
import copy
import yaml
import math

config_file_addr = 'config/tasks.yaml'

parser = argparse.ArgumentParser(description='Incremental training data processor')
parser.add_argument('percentage', type=int,
                    help='Percentage of the file kept')
parser.add_argument('output_directory', type=str,
                    help='the output directory for the file generated')
parser.add_argument('task_name', type=str,
                    help='the name of the task')
args = parser.parse_args()

# Get argument from the command line arguments
percentage = args.percentage
output_directory = args.output_directory
task_name = args.task_name

# Count the lines of the input data file
with open(f'{output_directory}/train_w_label.shuf', 'r') as data_file:
    length = len(data_file.read().split('\n')) - 1

with open(f'{output_directory}/train_w_label.shuf', 'r') as data_file:
    with open(f'{output_directory}/train.jsonl', 'a+') as train_file:
        with open(f'{output_directory}/train-labels.lst', 'a+') as label_file:
            for i in range(math.floor(length*percentage/100)):
                new_line_of_data = data_file.readline().strip()
                train_file.write(new_line_of_data.split('\t')[0] + '\n')
                label_file.write(new_line_of_data.split('\t')[1] + '\n')


# Load the config parameters in the yaml file
with open(config_file_addr, "r") as config_file:
    config = yaml.safe_load(config_file)

# Creat a new task with the task name and modify the training data and label to reflect where we have stored them
new_task_name = f'{task_name}_{str(percentage)}'
config[new_task_name] = copy.deepcopy(config[task_name])
config[new_task_name]['urls'] = ['']
config[new_task_name]['file_mapping']['train']['train_x'] = \
    '/'.join(f'{output_directory}/train.jsonl'.split('/')[3:])
config[new_task_name]['file_mapping']['train']['train_y'] = \
    '/'.join(f'{output_directory}/train-labels.lst'.split('/')[3:])

# Dump the yaml file back to where it came from
with open(config_file_addr, "w") as config_file:
    yaml.dump(config, config_file)
