#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=06:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=merqury_assemblies
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/merqury/merqury_assemblies_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/merqury/merqury_assemblies_%j.e


# Define raw data path, container path and output directory
BASE_DIR="/data/users/mkummer/assembly_annotation_course"
OUTPUT_DIR="$BASE_DIR/output"
MERQURY_DIR="$OUTPUT_DIR/merqury"
SIF_PATH="/containers/apptainer/merqury_1.3.sif"
export MERQURY="/usr/local/share/merqury"
READS="$BASE_DIR/input/raw_data/Etna-2/ERR11437333.fastq.gz"
READ_DB="$MERQURY_DIR/Etna-2.meryl"

# Ensure output directory exists
mkdir -p "$MERQURY_DIR"

# Define assembly names and corresponding file paths
assembly_names=(
  "flye"
  "hifiasm"
  "lja"
)

# Define assembly file paths corresponding to the assembly names
assembly_files=(
  "$OUTPUT_DIR/flye_assembly/Etna-2/assembly.fasta"
  "$OUTPUT_DIR/hifiasm_assembly/Etna-2.bp.p_ctg.fa"
  "$OUTPUT_DIR/lja_assembly/Etna-2/assembly.fasta"
)

# Check the read input before starting the container jobs.
if [[ ! -s "$READS" ]]; then
  echo "ERROR: Read file not found: $READS" >&2
  exit 1
fi

echo "Preparing meryl database from: $READS"
if [[ ! -d "$READ_DB" ]]; then
  apptainer exec \
    --bind "$BASE_DIR":"$BASE_DIR" \
    "$SIF_PATH" meryl count k=31 "$READS" output "$READ_DB"
else
  echo "Using existing meryl database: $READ_DB"
fi

# Run Merqury for each assembly.
for index in "${!assembly_names[@]}"; do
  name="${assembly_names[$index]}"
  assembly="${assembly_files[$index]}"

  if [[ ! -s "$assembly" ]]; then
    echo "WARN: Assembly for $name not found, skipping: $assembly" >&2
    continue
  fi

  echo "Running Merqury for $name: $assembly"
  apptainer exec \
    --bind "$BASE_DIR":"$BASE_DIR" \
    --env "MERQURY=$MERQURY" \
    "$SIF_PATH" "$MERQURY/merqury.sh" \
      "$READ_DB" \
      "$assembly" \
      "$MERQURY_DIR/$name"
done
