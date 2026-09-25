# Modular workflow training

A small example repository showcasing how to connect Modelblocks workflows!


## Overview

Default data processing steps:

1. Shapes are created using the [Geo-boundaries](https://github.com/modelblocks-org/module_geo_boundaries) module.
2. These shapes are used to collect powerplant data within a given region using the [Powerplants](https://github.com/modelblocks-org/module_powerplants) module.

<!-- Example module output -->
<p align="center">
  <img src="./figures/modulegraph.png" width="50%">
  <br>
  <em>Default modules.</em>
</p>

## Instructions

### Getting started

We use [`pixi`](https://pixi.sh/) as our software manager.
Follow their [installation instructions](https://pixi.prefix.dev/latest/installation/) to get started.

Once installed, clone or download this repository.

```shell
git clone git@github.com:modelblocks-org/modular_workflow_training.git
```

Once the code is in your machine, tell `pixi` to install the software dependencies.

```shell
cd modular_workflow_training/
pixi install --all
```

### Evaluate the modules

This workflow includes three modules.

- [Geo-boundaries](https://www.modelblocks.org/modules/module_geo_boundaries/): (sub)national boundaries for any nation.
- [Powerplants](https://www.modelblocks.org/modules/module_powerplants/): disaggregated powerplant statistics and trends.
- [Area potentials](https://www.modelblocks.org/modules/module_area_potentials/): custom available land area for renewable technologies.

There are integrated with two main files:
- `workflow/rules/`: Snakemake's call to the modules, file placement and "wiring".
- `config/modules/`: per module configuration (settings, assumptions, parameters, etc.).


### Brief example

Each module generates files according to its [`INTERFACE`](https://github.com/modelblocks-org/module_geo_boundaries/blob/main/INTERFACE.yaml), [configuration](./config/modules/geo_boundaries.yaml), and ["wiring"](./workflow/rules/module_geo_boundaries.smk).


Start by generating spatial boundaries for a particular regional scenario.

1. Request a shape (`PORTUGAL` or `BALTIC`).

    ```shell
    pixi run snakemake --cores 2 resources/geo_boundaries/results/PORTUGAL/shapes.parquet
    ```

2. Request a report for that shape.

    ```shell
    pixi run snakemake -c 2 resources/geo_boundaries/results/PORTUGAL/shapes.parquet --report
    ```

Now, request powerplant data.
The Powerplants module is already "wired" to the Geo-boundaries module (see [here](./workflow/rules/module_powerplants.smk)).

1. Request disaggregated powerplant data for a category (`wind`, `fossil`, `nuclear`, `large_solar`, etc.).

    ```shell
    pixi run snakemake -c 2 resources/powerplants/results/PORTUGAL/powerplants/unadjusted/wind.parquet
    ```
2. Re-run your report request!

    ```shell
    pixi run snakemake -c 2 resources/powerplants/results/PORTUGAL/powerplants/unadjusted/wind.parquet --report
    ```

3. How are the modules "connected". Use `rulegraph` or `modulegraph` to find out!

    ```shell
    pixi run rulegraph \
    --target=resources/powerplants/results/PORTUGAL/powerplants/unadjusted/wind.parquet
    ```

### Explore more options!

Now that you have successfully ran these "default" modules, explore what else you can do!

- Try integrating a new module by looking at their [interfaces](https://www.modelblocks.org/modules/), or...
- The [Area potentials](https://www.modelblocks.org/modules/module_area_potentials/) module is nearly integrated in this project. Which files and "wires" are missing?

> [!IMPORTANT]
> The Area potentials module processes large spatial rasters.
> Make sure you have a few GB available in your computer :wink:.

## `pixi` tasks

These are helpful commands to help you analyse results.


### `rulegraph` and `modulegraph`

These tasks render direct acyclic graphs (DAGs) of the Snakemake rules exectued to obtain results.

By default, these will render `rule all:` in the [Snakefile](./workflow/Snakefile).

```shell
pixi run rulegraph
pixi run modulegraph
```

To graph only the rules needed to produce a particular file, use `--target`:

```shell
pixi run rulegraph --target resources/geo_boundaries/results/BALTIC/shapes.parquet
pixi run modulegraph --target resources/geo_boundaries/results/BALTIC/shapes.parquet
```
