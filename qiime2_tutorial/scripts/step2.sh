#!/bin/bash
#SBATCH --time=2:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=20G
#SBATCH --ntasks-per-node=8
#SBATCH --job-name=QIIME2


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime dada2 denoise-paired   --i-demultiplexed-seqs soil-paired-end-demux.qza   --o-table soil-table   --o-representative-sequences soil-rep-seqs   --p-trim-left-f 0   --p-trim-left-r 0   --p-trunc-len-f 240   --p-trunc-len-r 200 --p-n-threads $SLURM_TASKS_PER_NODE --verbose


