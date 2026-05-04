# Modular workflow training

A small example repository showcasing how to connect Modelblocks workflows.


## Overview

Data processing steps:

1. Shapes are created using the geo-boundaries module.
2. They are passed to a second module to showcase how modules feed into each other.


## Development
<!-- Please do not modify this templated section -->

We use [`pixi`](https://pixi.sh/) as our package manager for development.
Once installed, run the following to clone this repository and install all dependencies.

```shell
git clone git@github.com:modelblocks-org/modular_workflow_training.git
cd modular_workflow_training
pixi install --all
```

For testing, simply run:

```shell
pixi run test-integration
```

To test a minimal example of a workflow using this module:

```shell
pixi shell    # activate this project's environment
cd tests/integration/  # navigate to the integration example
snakemake --use-conda --cores 2  # run the workflow!
```
