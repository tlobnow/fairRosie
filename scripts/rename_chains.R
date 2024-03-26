#!/usr/bin/env Rscript

library(bio3d)

# Intercept variables from shell script
args <- commandArgs(trailingOnly = TRUE)
HOME_DIRECTORY <- args[1]
STRUCTURE_PATH <- args[2]
OUT_PATH       <- args[3]

print(paste0("Home Dir: ", HOME_DIRECTORY))
print(paste0("Structure Path: ", STRUCTURE_PATH))
print(paste0("Output: ", OUT_PATH))

# Define input directory for the structure
INPUT <- STRUCTURE_PATH

# Read the pdb file
pdb <- read.pdb(INPUT)

int <- atom.select(pdb, chain = LETTERS[seq(from = 1, to = 24, by = 2)]) 
ind <- atom.select(pdb, chain = LETTERS[seq(from = 2, to = 24, by = 2)]) 

# trim PDB to selection
pdb2 <- trim.pdb(pdb, int)
pdb3 <- trim.pdb(pdb, ind)

# Define the old chain identifiers
old_chains <- rev(LETTERS[seq(from = 1, to = 24, by = 2)])

# Define the new chain identifiers
new_chains <- letters[seq(from = 1, to = 12, by = 1)]
new_chains2 <- LETTERS[seq(from = 1, to = 12, by = 1)]

# Iterate through each chain
for (i in seq_along(old_chains)) {
  # Rename the chain
  pdb2$atom$chain[pdb2$atom$chain == old_chains[i]] <- new_chains[i]
  print(old_chains[i])
}

for (i in seq_along(new_chains)) {
  # Rename the chain
  pdb2$atom$chain[pdb2$atom$chain == new_chains[i]] <- new_chains2[i]
  print(new_chains[i])
}

# Define the old chain identifiers
old_chains <- LETTERS[seq(from = 2, to = 24, by = 2)]

# Define the new chain identifiers
new_chains  <- letters[seq(from = 13, to = 24, by = 1)]  
new_chains2 <- LETTERS[seq(from = 13, to = 24, by = 1)]  

# Iterate through each chain
for (i in seq_along(old_chains)) {
  # Rename the chain
  pdb3$atom$chain[pdb3$atom$chain == old_chains[i]] <- new_chains[i]
}

for (i in seq_along(new_chains)) {
  # Rename the chain
  pdb3$atom$chain[pdb3$atom$chain == new_chains[i]] <- new_chains2[i]
  print(new_chains[i])
}

renamed_pdb <- cat.pdb(pdb2, pdb3, rechain = FALSE)

base_name        <- basename(tools::file_path_sans_ext(INPUT))
output_file      <- paste0(OUT_PATH, "/", base_name, "_renamed_chains.pdb")

# write the new pdb object to file
write.pdb(renamed_pdb, file=output_file)
