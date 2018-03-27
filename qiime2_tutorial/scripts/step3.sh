#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=5G
#SBATCH --ntasks-per-node=2
#SBATCH --job-name=QIIME2_Table


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime feature-table summarize  --i-table soil-table.qza  --o-visualization soil-table.qzv  --m-sample-metadata-file soil-metadata.tsv 
qiime feature-table tabulate-seqs   --i-data soil-rep-seqs.qza   --o-visualization soil-rep-seqs.qzv


