#!/bin/sh
#SBATCH --job-name=latest_2benchmark          #Job name
#SBATCH --ntasks=64                 #Number of tasks/How many parallel jobs to run -> equivalent to -n in peacock
#SBATCH --mem-per-cpu=5000           #Memory (120 gig/node) -> use just enough so your memory usage is 70-80%
#SBATCH --nodes=2                   #xueyang added
#SBATCH --cpus-per-task=1           #xueyang added
#SBATCH --time=8-00:00:00             #Walltime hh:mm:ss
#SBATCH --output=output-%j.out #Output and error log name
#SBATCH --mail-type=ALL             #When to email user: NONE,BEGIN,END,FAIL,REQUEUE,ALL
#SBATCH --mail-user= wuxueyang@ufl.edu       #Email address to send mail to
#SBATCH --qos=michael.tonks                #Allocation group name, add -b for burst job
##SBATCH --array=1-200%10           #Used to submit multiple jobs with one submit

srun --mpi=pmi2 /home/wuxueyang/projects/moose/modules/phase_field/phase_field-opt -i /ufrc/michael.tonks/wuxueyang/latest_2benchmark/periodic_square.i


