#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=trinity_assembly
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/trinity_assembly/Etna-2/trinity_assembly_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/trinity_assembly/Etna-2/trinity_assembly_error_%j.e


#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/assembly_annotation_course/input"
FASTQ_FILE="/data/users/mkummer/assembly_annotation_course/input/RNA-Seq/"
FASTQ_R1= "$FASTQ_FILE/ERR754081_1.fastq.gz"
FASTQ_R2= "$FASTQ_FILE/ERR754081_2.fastq.gz"
RESULTS_DIR="/data/users/mkummer/assembly_annotation_course/output/trinity_assembly/Etna-2"
SIF_PATH="/containers/apptainer/trinity_2.15.2.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

#Run trinity assembly on the FASTQ file
apptainer exec \
  --bind "$READS_DIR":"$READS_DIR" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "/data":"/data" \
  "$SIF_PATH" Trinity \
    --seqType fq \
    --left "$FASTQ_R1" \
    --right "$FASTQ_R2" \
    --max_memory 64G \
    --CPU 16 \
    --output "$RESULTS_DIR"
