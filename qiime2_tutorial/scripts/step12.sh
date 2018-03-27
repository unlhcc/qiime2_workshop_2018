#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=10G
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=QIIME2_filter


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime feature-table filter-samples   --i-table soil-table.qza   --m-metadata-file soil-metadata.tsv   --p-where "Type='rhizosphere'"   --o-filtered-table rhizo-table.qza

qiime composition add-pseudocount   --i-table rhizo-table.qza   --o-composition-table comp-rhizo-table.qza


