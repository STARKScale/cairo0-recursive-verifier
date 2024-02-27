# Setup and Execution Guide for Stone Prover with Cairo

This guide provides step-by-step instructions for working with the Stone Prover Docker container and compiling, running, and verifying Cairo code. Ensure Docker is installed and running on your machine before proceeding.

## Preparing the Environment

### Copying the Cairo Code to the Stone Prover Docker Container

To start, you need to copy the Cairo code into the Stone Prover Docker container. Execute the following commands in your terminal:

```bash
# Find the container ID for the 'prover' container
CONTAINER_ID=$(docker ps -aqf "name=^prover$")

# Copy the 'mapper/' directory to the '/app/' directory in the 'prover' container
docker cp mapper/ $CONTAINER_ID:/app/
```

# In the stone prover container
Once the code is in the container, follow these steps to compile and execute it.

## Compiling the Cairo Code
``` bash
cairo-compile mapper.cairo --output mapper_compiled.json --proof_mode --no debug_info
```

## Generating the Execution Trace
``` bash
cairo-run \
    --program=mapper_compiled.json \
    --layout=recursive \
    --air_public_input=mapper_public_input.json \
    --air_private_input=mapper_private_input.json \
    --trace_file=mapper_trace.json \
    --memory_file=mapper_memory.json \
    --print_output \
    --proof_mode

```
## Running the CPU Air Prover
```bash
cpu_air_prover --out_file=mapper_proof.json --private_input_file=mapper_private_input.json --public_input_file=mapper_public_input.json --prover_config_file=cpu_air_prover_config.json --parameter_file=cpu_air_params.json --generate_annotations
```

## Copying the Output Back to the Repository
```bash
# Find the container ID for the 'prover' container
CONTAINER_ID=$(docker ps -aqf "name=^prover$")

# Copy the 'mapper/' directory to the '/app/' directory in the 'prover' container
docker cp $CONTAINER_ID:/app/mapper/ cairo_programs/
```

# Setting Up the Cairo Language Environment
## Initial Setup
### Assuming pyenv is not installed:
macOS

```bash
brew install pyenv pyenv-virtualenv
```
Add the following to your .zshrc or .bashrc:

```bash
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```
### Creating the Python Virtual Environment
```bash
pyenv install 3.9
pyenv virtualenv 3.9 stone-prover-cairo0-verifier2
```
### Activating the Virtual Environment
``` bash
pyenv activate stone-prover-cairo0-verifier2
```
### Installing Dependencies
If jq is not installed:

``` bash
brew install jq
```

# Running the Cairo Verifier
## Cairo Verifier with one Proof
Navigate to the cairo-lang directory and execute:

``` bash

jq '{ proof: . }' ../../cairo_programs/mapper/mapper_proof.json > cairo_verifier_input.json
cairo-compile --cairo_path=./src src/starkware/cairo/cairo_verifier/layouts/all_cairo/cairo_verifier.cairo --output cairo_verifier.json --no_debug_info
cairo-run \
    --program=cairo_verifier.json \
    --layout=recursive \
    --program_input=cairo_verifier_input.json \
    --trace_file=cairo_verifier_trace.json \
    --memory_file=cairo_verifier_memory.json \
    --print_output
```

## Combining Two Proofs for the Recursive Verifier 
Assuming one proof is in folder mapper and the other in foler mapper2

```bash
jq -s '{ proof1: .[0], proof2: .[1] }' ../../cairo_programs/mapper/mapper_proof.json ../../cairo_programs/mapper/mapper_proof.json > combined_verifier_input.json

cairo-compile --cairo_path=./src src/starkware/cairo/cairo_verifier/layouts/all_cairo/merge_cairo_verifier.cairo --output merge_cairo_verifier.json --no_debug_info

cairo-run \
    --program=merge_cairo_verifier.json \
    --layout=recursive \
    --program_input=combined_verifier_input.json \
    --trace_file=cairo_combined_verifier_trace.json \
    --memory_file=cairo_combined_verifier_memory.json \
    --print_output
```
