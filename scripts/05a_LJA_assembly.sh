#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=lja_assembly
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/lja_assembly/Etna-2/lja_assembly_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/lja_assembly/Etna-2/lja_assembly_error_%j.e


#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/assembly_annotation_course/input"
FASTQ_FILE="/data/users/mkummer/assembly_annotation_course/input/ERR11437333.fastq.gz"
RESULTS_DIR="/data/users/mkummer/assembly_annotation_course/output/lja_assembly/Etna-2"
SIF_PATH="/containers/apptainer/lja-0.2.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

#Run lja assembly on the FASTQ file
apptainer exec \
  --bind "$READS_DIR":"$READS_DIR" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "/data":"/data" \
  "$SIF_PATH" lja --threads 16 \
  --diploid \
  --reads "$FASTQ_FILE" \
  -o "$RESULTS_DIR"
