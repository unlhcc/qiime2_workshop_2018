#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=20G
#SBATCH --ntasks-per-node=8
#SBATCH --job-name=QIIME2_metrics


set -e
cd $WORK/qiime2-tut

module load qiime2

rm -Rf metrics
qiime diversity core-metrics-phylogenetic   --i-phylogeny soil-rooted-tree.qza   --i-table soil-table.qza   --p-sampling-depth 340   --m-metadata-file soil-metadata.tsv   --output-dir metrics --verbose --p-n-jobs $SLURM_TASKS_PER_NODE


