# fairRosie

# Rosetta Installation Guide

## Acquiring License

- Get an academic license for Rosetta: [http://c4c.uwc4c.com/express_license_technologies/rosetta](http://c4c.uwc4c.com/express_license_technologies/rosetta)

## Downloading

### On Raven:
```bash
curl -u user_name:password https://www.rosettacommons.org/downloads/academic/2023/wk6/rosetta.source.release-340.tar.bz2 -o rosetta.source.release-340.tar.bz2
```

### On Local Computer:
- Download the source code [here](https://www.rosettacommons.org/software/academic)

## Decompression

```bash
tar xjf rosetta.source.release-340.tar.bz2
```

## Navigating to Source Directory

```bash
cd main/source
```

## Setting up Virtual Environment

- Create a virtual python environment using conda:
```bash
conda create --name rosetta python=3.10
```
- Activate the environment:
```bash
conda activate rosetta
```
- Deactivate the environment:
```bash
conda deactivate
```

## Installing Dependencies

```bash
pip install SCons
```

## Compilation

- The basic compilation command is:
```bash
./scons.py -j<number_of_processors_to_use> mode=release bin
```
Replace `<number_of_processors_to_use>` with a number one processor fewer than your computer has. Expect compilation to take a while (hours on one processor). 

- On Raven:
```bash
./scons.py -j 36 mode=release bin
```

- For MPI installation on HPC (advisable on Raven):
```bash
./scons.py -j 30 mode=release bin extras=mpi
```

Note: Both versions can be installed on the same account.

## Unit Tests

- Install and run unit tests for ROSETTA to check whether installation was successful and build is okay. 
  [Official Documentation](https://www.rosettacommons.org/docs/latest/development_documentation/test/run-unit-test)

- Unit tests can be used to verify that ROSETTA has installed properly in your /home directory. First, we need to install the unit tests. From the `~/rosetta.source*/main/source`, use the following commands to install the unit tests:
```bash
scons mode=debug
scons mode=debug cat=test
```

- When the unit tests finish installing, you can run them using:
```bash
python test/run.py --mode=debug -j
```

This will initiate the unit tests. It will take several hours for all of the unit tests to finish. Keep an eye on it. At the end, the summary of the results of tests is printed into the terminal.

