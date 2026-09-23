#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=45gb
#SBATCH --time=02:00:00
#SBATCH --partition=pshort_el8
#SBATCH --job-name=jellyfish_kmer
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/jellyfishkmer/Etna-2/jellyfish_kmer_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/jellyfishkmer/Etna-2/jellyfish_kmer_error_%j.e


#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/assembly_annotation_course/input"
FASTQ_FILE="/data/users/mkummer/assembly_annotation_course/input/ERR11437333.fastq.gz"
RESULTS_DIR="/data/users/mkummer/assembly_annotation_course/output/jellyfish_kmer/Etna-2"
SIF_PATH="/containers/apptainer/jellyfish-2.2.6--0.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

#Run Jellyfish on the FASTQ file
apptainer exec \
  --bind "$READS_DIR":"$READS_DIR" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "/data":"/data" \
  "$SIF_PATH" jellyfish count -C -m 31 -s 5G -t 4 \
  <(gzip -dc "$FASTQ_FILE") \
  -o "$RESULTS_DIR/reads.jf"

apptainer exec \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "/data":"/data" \
  "$SIF_PATH" jellyfish histo -t 4 "$RESULTS_DIR/reads.jf" > "$RESULTS_DIR/reads.histo"

