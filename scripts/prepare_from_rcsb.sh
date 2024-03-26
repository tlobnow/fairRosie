#!/usr/bin/env bash

INPUT="${1:-/u/$USER/fairRosie/from_rcsb/}"
OUTPUT="/u/$USER/fairRosie/flags/"
BASE_NAME=$(basename "$INPUT")

for FILE in ${INPUT}/*.pdb ;do
	if [[ -f "$FILE" ]]; then
		echo "${BASE_NAME}/$(basename $FILE)"
	fi
done > "$OUTPUT/ddg_prep.txt"
