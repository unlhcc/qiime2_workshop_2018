#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=10G
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=QIIME2_ancom


set -e
cd $WORK/qiime2-tut

module load qiime2

for CATEGORY in "NitrogenLevel" "Genotype" "GrowthStage"; do

	qiime composition ancom   --i-table comp-rhizo-table.qza   --m-metadata-file soil-metadata.tsv   --m-metadata-column ${CATEGORY}   --o-visualization ancom-${CATEGORY}.qzv

done

