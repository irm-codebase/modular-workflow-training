
with open(workflow.source_path("../../config/modules/geo_boundaries.yaml"), "r") as file:
    geo_boundaries_config = yaml.safe_load(file.read())


module module_geo_boundaries:
    snakefile: github("modelblocks-org/module_geo_boundaries", path="workflow/Snakefile", tag="v0.2.1")
    config: geo_boundaries_config
    pathvars:
        logs="resources/modules/geo_boundaries/logs",
        resources="resources/modules/geo_boundaries/resources",
        results="resources/modules/geo_boundaries/results",
        # shapes="results/geo_boundaries/shapes.parquet"

use rule * from module_geo_boundaries as module_geo_boundaries_*


