#!/bin/bash
#SBATCH --account=jlab
#SBATCH --time=12:00:00          # Run time in hh:mm:ss
#SBATCH --mem-per-cpu=2024       # Maximum memory required per CPU (in megabytes)
#SBATCH --job-name=do_sth
#SBATCH --ntasks=36
#SBATCH --output=/home/jias/out/sth-%A_%a.out
#SBATCH --error=/home/jias/out/sth-%A_%a.err

# Load the default version of GNU parallel.
module purge
module load gcc/7.1.0-4bgguyp
module load parallel

# When running a large number of tasks simultaneously, it may be
# necessary to increase the user process limit.
ulimit -u 10000

# This specifies the options used to run srun. The "-N1 -n1" options are
# used to allocates a single core to each task.
srun="srun --exclusive -N1 -n1"
JOBLOG=/home/jias/out/do_sth.progress
LOGDIR=/lcrc/project/jlab/data/hallc/csv/replay/log/

# This specifies the options used to run GNU parallel:
#
#   --delay of 0.2 prevents overloading the controlling node.
#
#   -j is the number of tasks run simultaneously.
#
#   The combination of --joblog and --resume create a task log that
#   can be used to monitor progress.
#
#parallel="parallel --delay 0.2 -j $SLURM_NTASKS --joblog ${JOBLOG} --resume --tmpdir ${TMPDIR}"
#parallel="parallel --delay 0.2 -j $SLURM_NTASKS --joblog ${JOBLOG} --tmpdir ${TMPDIR}"
parallel="parallel --delay 0.2 -j $SLURM_NTASKS --joblog ${JOBLOG}"

# Run the script, using GNU parallel and srun. Parallel
# will run the runtask script for the numbers 1 through $SLURM_NTASKS 
$parallel "$srun ./do_sth.sh {1} &> $LOGDIR/do_sth.sh.{1}" ::: {1..58}
#$parallel "$srun ./do_sth2.sh {1} &> $LOGDIR/do_sth2.sh.{1}" ::: {33..42}
