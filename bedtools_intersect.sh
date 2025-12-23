#!/bin/bash
set xeuo --pipefail
#SBATCH --job-name=bedtools_intersect       # Job name
#SBATCH --ntasks=1                         # Number of tasks (typically 1 for single script)
#SBATCH --cpus-per-task=2                  # Number of CPUs per task
#SBATCH --mem=10GB                         # Memory per node
#SBATCH --time=00:30:00                    # Walltime (30 minutes)
#SBATCH --nodes=1                          # Number of nodes


#set path
cd /scratch/project_mnt/S0065/judy/rgt_multi_gen_UMR-seq_2024/analysis/trimmed_align_bowtie2_epic2

# Load necessary modules (e.g., bedtools)
module load bedtools

# Define input files (replace these names)
sample1="sample_name"
sample2="sample_name"

#overlap one
bedtools intersect \
-a "$sample1".50.epic2.bed \
-b "$sample2".50.epic2.bed \
-r \
-f 0.2 \
-wa -u \
> "overlap_ab_u_"$sample1"_"$sample2".bed

#inverse overlap
bedtools intersect \
-b "$sample1".50.epic2.bed \
-a "$sample2".50.epic2.bed \
-r \
-f 0.2 \
-wa -u \
> "overlap_ba_u_"$sample1"_"$sample2".bed

bedtools intersect \
-a "$sample1".50.epic2.bed \
-b "$sample2".50.epic2.bed \
-r \
-f 0.2 \
-v \
> "overlap_ab_v_"$sample1"_"$sample2".bed


echo "Job finished!"
