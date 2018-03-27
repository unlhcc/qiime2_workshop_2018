#!/bin/bash
#SBATCH --time=4:00:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=30G
#SBATCH --ntasks-per-node=8
#SBATCH --job-name=QIIME2_tax


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime feature-classifier classify-sklearn   --i-classifier gg-13-8-99-515-806-nb-classifier.qza   --i-reads soil-rep-seqs.qza   --o-classification soil-taxonomy.qza --verbose --p-n-jobs $SLURM_TASKS_PER_NODE
