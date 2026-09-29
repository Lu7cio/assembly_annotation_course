#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=merqury_assemblies
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/merqury_assemblies_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/merqury_assemblies_%j.e

#Define raw data path, container path and output directory
BASE_DIR="/data/users/mkummer/assembly_annotation_course"
OUTPUT_DIR="$BASE_DIR/output"
BUSCO_DIR="$OUTPUT_DIR/BUSCO"
SIF_PATH="/containers/apptainer/merqury_1.3.sif"

#Ensure output directory exists
mkdir -p "$BUSCO_DIR"

#Define assembly names and corresponding file paths
assembly_names=(
  "flye"
  "hifiasm"
  "lja"
)

#Define assembly file paths corresponding to the assembly names
assembly_files=(
  "$OUTPUT_DIR/flye_assembly/Etna-2/assembly.fasta"
  "$OUTPUT_DIR/hifiasm_assembly/Etna-2/etna2.bp.p_ctg.fa"
  "$OUTPUT_DIR/lja_assembly/Etna-2/k501/disjointigs.fasta"
)

#Run BUSCO for each assembly
for index in "${!assembly_names[@]}"; do
  name="${assembly_names[$index]}"
  assembly="${assembly_files[$index]}"
  mode="genome"

  if [[ "$name" == "trinity" ]]; then
    mode="transcriptome"
  fi

  if [[ ! -s "$assembly" ]]; then
    echo "WARN: Assembly for $name not found, skipping: $assembly" >&2
    continue
  fi

  echo "Running BUSCO for $name: $assembly"
  apptainer exec \
    --bind "$BASE_DIR":"$BASE_DIR" \
    "$SIF_PATH" busco \
      --input "$assembly" \
      --output "$name" \
      --out_path "$BUSCO_DIR" \
      --lineage_dataset "brassicales_odb10" \
      --mode "$mode" \
      --cpu 16
done
