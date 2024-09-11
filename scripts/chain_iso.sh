#!/bin/bash

# Input PDB file
input_file="${1:-input.pdb}"

# Output PDB file
output_file="${2:-${input_file%.*}_iso.pdb}"

# Chains to be selected (default: A-F)
chains="${3:-A-F}"

# Check if the input file exists
if [ -f "$input_file" ]; then
    # Filter the PDB file by the specified chains and save to output file
    grep -E '^ATOM|^HETATM' "$input_file" | awk -v chains="$chains" '$5 ~ "["chains"]" {print}' > "$output_file"
    echo "Processing complete. Output saved to $output_file"
else
    echo "Error: $input_file does not exist."
    exit 1
fi

# ./chain_iso.sh ../input_files/5uzb.pdb ../input_files/5uzb_iso.pdb  A-DMN
