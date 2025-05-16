## What

You want to turn a string (a value) into a variable (a symbol) in a number of files, so that if you have multiple values for this variable you may keep various configurations in order to set them and reset them, change them back and forth, possibly during runtime, without having to remember how to adjust every parameter.

## Install dependencies

```bash
chmod +x install.sh; ./install.sh
```

## Set values and files

For each unique configuration set the desired values and the affected files in some file under `params/`, e.g. `params.yaml`

```bash
params/params.yaml
```

## Validate that affected files exist beforehand

```bash
make validate-paths PARAM_FILE=params/params.yaml
```



## Generate symbols for each value

```bash
make generate-symbols PARAM_FILE=params/params.yaml
```

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
make dereference PARAM_FILE=params/params.yaml
```
