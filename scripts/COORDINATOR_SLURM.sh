#!/bin/bash -l
#
# Name of SLURM-job
#SBATCH -J ROSETTA
#
# Standard output and error:
#SBATCH -o job_%A_%a.out        # Standard output, %A = job ID, %a = job array index
#
# Number of nodes and MPI tasks per node:
#SBATCH --ntasks=1
#SBATCH --constraint="gpu"
#
# We will use 4 GPUs:
#SBATCH --gres=gpu:a100:4
#SBATCH --cpus-per-task=72
#SBATCH --mem=500000
##
#SBATCH --mail-type=NONE
#SBATCH --mail-user=$USER@mpiib-berlin.mpg.de
#SBATCH --time=24:00:00

# Activate the environment
conda activate rosetta

# Load modules
module load R/4.3

# Load user parameters
source /u/$USER/fairRosie/scripts/user_parameters.sh
source $MYROSETTA/scripts/FUNCTIONS

# Get the path to the structure to be analyzed from pdb_list
if [ "$run_relaxation_protocol" == "True" ]; then

	S=$(head -${SLURM_ARRAY_TASK_ID} $INPUT_LIST | tail -1)

	echo "Array-ID is: ${SLURM_ARRAY_TASK_ID}"
	echo "Path (S) to structure is: $S"

	# Extract the structure name from the path
	title=$(basename "$S" .pdb)
	echo "Title of structure is: $title"

	# Create a directory for the structure's analysis
	analysis_dir="$MYROSETTA/output_files/$title"
	mkdir -p "$analysis_dir"
	echo "Analysis directory created: $analysis_dir"

elif [ "$run_symmetric_docking_protocol" == "True" ]; then

	# Create an array of .pdb files
	pdb_files=("$INPUT_DIR"/*.pdb)

	# Use SLURM_ARRAY_TASK_ID to get the specific pdb file
	S="${pdb_files[$SLURM_ARRAY_TASK_ID-1]}"

	echo "Array-ID is: ${SLURM_ARRAY_TASK_ID}"
	echo "Path (S) to structure is: $S"

	# Extract the structure name from the path
	title=$(basename "$S" .pdb)
	echo "Title of structure is: $title"

else
	echo "No protocol selected. Stopping."
	exit 1
fi

# Change to the ROSETTA scripts directory for analysis
cd $MYROSETTA/scripts

if [ "$run_relaxation_protocol" == "True" ]; then

	# Determine the interfaces of chain A using the R script
	chains=$(determine_interfaces "$MYROSETTA" "$S")
	echo "Chains interfacing with A are: $chains"

	echo ""
	echo "************** FINISHED INTERFACE CHECK **************"
	echo ""

	# Perform relaxation on the structure
	relax_rosetta "$analysis_dir" "$S" "$MYROSETTA"

	echo ""
	echo "************** FINISHED RELAXATION PROTOCOL **************"
	echo ""

	# Change to the analysis directory for further processing.
	cd "$analysis_dir"

	# Compute the total score
	score_rosetta "$analysis_dir" "$S"
	echo "Finished scoring."

	# Create total_scores file from default.sc
	process_default_sc "$analysis_dir" "$S"
	echo "Finished processing default.sc."

	# Analyze the interfaces and compute energies
	analyze_interfaces "$analysis_dir" "$chains"
	echo "Finished analyzing the chains."

	# Collate scores and clean up
	paste total_scores_$title.sc dG* > scores_$title.sc
	rm dG* total_scores_$title.sc

fi

if [ "$run_symmetric_docking_protocol" == "True" ]; then

	# Create a directory for the renamed chain structure's analysis
        renamed_dir="${INPUT_DIR}_renamed_chains"
        mkdir -p "$renamed_dir"
        echo "Directory for renamed chains created: $renamed_dir"

	Rscript rename_chains.R "$MYROSETTA" "$S" "$renamed_dir"
	echo "Finished renaming the chains."

	# Create an array of .pdb files
        pdb_files=("$renamed_dir"/*_renamed_chains.pdb)

        # Use SLURM_ARRAY_TASK_ID to get the specific pdb file
        S="${pdb_files[$SLURM_ARRAY_TASK_ID-1]}"
	echo "Array-ID is: ${SLURM_ARRAY_TASK_ID}"
        echo "New Path (S) to structure is: $S"

	#symmetric_docking_rosetta "$S" "$renamed_dir"
	#echo "Finished docking."

	# Change to the analysis directory for further processing.
        cd "$renamed_dir"

	# Create an array of .pdb files
        pdb_files=("$renamed_dir"/*.pdb)

        # Compute the total score
        score_rosetta "$renamed_dir" "$S"
        echo "Finished scoring."

fi
