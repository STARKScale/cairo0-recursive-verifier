First copy the files to stone prover docker
```
 docker cp mapper/ 6d7641368d2f:/app/
```
In stone prover
### Compile
```
cairo-compile mapper.cairo --output mapper_compiled.json --proof_mode --no_debug_info
```

### Get public/private/trace/memory

```
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

### CPU Air Prover

```
cpu_air_prover --out_file=mapper_proof.json --private_input_file=mapper_private_input.json --public_input_file=mapper_public_input.json --prover_config_file=cpu_air_prover_config.json --parameter_file=cpu_air_params.json -generate_annotations
```

### Copy it back to repo
```
docker cp 6d7641368d2f:/app/mapper2/ cairo_programs/
```

# For cairo lang
## To set up this repo
Assuming you have no pyenv installed
Macos
```
brew install pyenv pyenv-virtualenv
```
You then need to add this to .zshrc:
```
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```
Now you build up the pythone virual environment
```
pyenv install 3.9
pyenv virtualenv 3.9 stone-prover-cairo0-verifier2
```
## Activate and setup the virtual environment
```
pyenv activate stone-prover-cairo0-verifier2
```

## If no jq
```
brew install jq
```
## One run with the cairo verifier
```
cd cairo-lang
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

## To parse two proofs as input to the verifier and make recursive verifier work
```
jq -s '{ proof1: .[0], proof2: .[1] }' ../../cairo_programs/mapper/mapper_proof.json ../../cairo_programs/mapper/mapper_proof.json
> combined_verifier_input.json

cairo-compile --cairo_path=./src src/starkware/cairo/cairo_verifier/layouts/all_cairo/merge_cairo_verifier.cairo --output merge_cairo_verifier.json --no_debug_info

cairo-run \
    --program=merge_cairo_verifier.json \
    --layout=recursive \
    --program_input=combined_verifier_input.json \
    --trace_file=cairo_combined_verifier_trace.json \
    --memory_file=cairo_combined_verifier_memory.json \
    --print_output
```

