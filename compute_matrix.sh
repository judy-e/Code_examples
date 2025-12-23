#!/bin/bash  -l
set -xeuo pipefail

echo ------------------------------------------------------
echo SBATCH: working directory is $SLURM_SUBMIT_DIR
echo SBATCH: job identifier is $SLURM_JOBID
echo SBATCH: array_ID is ${SLURM_ARRAY_TASK_ID}
echo ------------------------------------------------------


echo working dir is $PWD

#cd into work dir
echo changing to SLURM_SUBMIT_DIR
cd "$SLURM_SUBMIT_DIR"
echo working dir is now $PWD


########## ID #################

#get job ID
#use sed, -n supression pattern space, then 'p' to print item number {PBS_ARRAY_INDEX} eg 2 from {list}
ID="$(/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${LIST})"

echo sample being mapped is $ID


######### Modules #################

conda activate ${conda_env}

module load deeptools

######Script#######

#go into analysis
#cd analysis
#echo working directory is now $PWD

#make directory for heatmaps
mkdir -p compute_matrix

####With all bigwigs#########
computeMatrix scale-regions \
-S ${bw_dir}/${ID}.bigWig \
-R ${bed_file} \
-b 2000 -a 2000 \
-bs 100 \
--outFileNameMatrix compute_matrix/${ID}_plotvalues.tab \
-o compute_matrix/${ID}_UMR_matrix.gz


#echo compute matrix finished, now running plot heatmap

####plot heatmap#########
plotHeatmap \
-m compute_matrix/${ID}_UMR_matrix.gz \
-min 0 \
-max 1.5 \
--yMin 0 \
--yMax 3 \
-o compute_matrix/${ID}_UMR_heatmap.png

####plotprofile for plot data ####
plotProfile \
-m compute_matrix/${ID}_matrix.gz \
--outFileNameData compute_matrix/${ID}_UMR_profile.tab \
-o compute_matrix/${ID}_profile.png

echo "finished running"
