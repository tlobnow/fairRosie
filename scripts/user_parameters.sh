#!/bin/bash -l

run_relaxation_protocol=False #True
run_symmetric_docking_protocol=True

# Define environment variables
ROSETTA3='/u/flobnow/rosetta/main/source'
MYROSETTA='/u/flobnow/fairRosie'

if [ "$run_relaxation_protocol" == "True" ]; then
	# Define the path to the structures to be processed
	#INPUT_LIST=$MYROSETTA/flags/ddg_prep_BDLD_57.txt
	#INPUT_LIST=$MYROSETTA/flags/ddg_prep_7beq.txt
	#INPUT_LIST=$MYROSETTA/flags/ddg_prep_BDLD_6.txt
	INPUT_LIST=$MYROSETTA/flags/example.txt

	# Compute number of structures in list
	NUM=$(wc -l < $INPUT_LIST)
elif [ "$run_symmetric_docking_protocol" == "True" ]; then
	# Define the path to the structures to be processed
	#INPUT_DIR=$MYROSETTA/output_files/BDLD_6_BAY07541.1__Calothrix_sp_NIES-2098_x10_model_2
	INPUT_DIR=$MYROSETTA/output_files/6I3N

	# Compute number of structures in list
	NUM=$(find "$INPUT_DIR" -type f -name "*.pdb" | wc -l)
else
	echo "Please set the protocol you wish to run to 'True'"
fi

echo "Number of structures:" $NUM
