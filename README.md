## What

You want to turn a string (a value) into a variable (a symbol) in a number of files, so that if you have multiple values for this variable you may keep various configurations and change them back and forth, possibly during runtime.

## Install dependencies

```bash
chmod +x install.sh; ./install.sh
```

## Set values, symbols, and files

Set the desired symbols, their values, and the affected files in some file under `params/`

```bash
params/params.yaml
```

for each unique configuration.

# Usage

## → (reference)

Turn a value into a symbol with

```bash
# use make dry-reference for a dry run
make reference PARAM_FILE=params/params.yaml
```

## * (dereference)

Turn a symbol into a value with

```bash
# use make dry-dereference for a dry run
make dereference 
```
