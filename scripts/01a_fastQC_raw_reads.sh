#!/usr/bin/env bash

#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=2000M
#SBATCH --time=02:00:00
#SBATCH --partition=pshort_el8
#SBATCH --job-name=fastqc_analysis
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/fastqc/Etna-2/fastqc_analysis_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/fastqc/Etna-2/fastqc_analysis_error_%j.e

#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/assembly_annotation_course/input"
FASTQ_FILE="/data/users/mkummer/assembly_annotation_course/input/ERR11437333.fastq.gz"
RESULTS_DIR="/data/users/mkummer/assembly_annotation_course/output/fastqc/Etna-2"
SIF_PATH="/containers/apptainer/fastqc-0.12.1.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Run FastQC on the selected raw reads file
apptainer exec \
  --bind "$READS_DIR":"$READS_DIR" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "/data":"/data" \
  "$SIF_PATH" fastqc -t 2 -o "$RESULTS_DIR" "$FASTQ_FILE"


