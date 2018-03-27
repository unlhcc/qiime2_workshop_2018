#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=20G
#SBATCH --ntasks-per-node=2
#SBATCH --job-name=QIIME2_beta


set -e
cd $WORK/qiime2-tut

module load qiime2

for METRIC in "unweighted_unifrac" "weighted_unifrac" "jaccard" "bray_curtis"; do
	for CATEGORY in "NitrogenLevel" "Type" "Genotype" "GrowthStage"; do

		echo "Doing ${METRIC} on ${CATEGORY}"
		qiime diversity beta-group-significance   --i-distance-matrix metrics/${METRIC}_distance_matrix.qza   --m-metadata-file soil-metadata.tsv   --m-metadata-column ${CATEGORY}  --o-visualization metrics/${METRIC}-${CATEGORY}-significance.qzv   --p-pairwise


	done

done



