
with open(workflow.source_path("../../config/modules/geo_boundaries.yaml"), "r") as file:
    geo_boundaries_config = yaml.safe_load(file.read())

module module_geo_boundaries:
    config: geo_boundaries_config
    snakefile: github("modelblocks-org/module_geo_boundaries", path="workflow/Snakefile", tag="v1.0.0")
    pathvars:
        logs=f"resources/modules/geo_boundaries/logs",
        resources=f"resources/modules/geo_boundaries/resources",
        results=f"resources/modules/geo_boundaries/results",
use rule * from module_geo_boundaries as module_geo_boundaries_*
