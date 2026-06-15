
with open(workflow.source_path("../../config/modules/powerplants.yaml"), "r") as file:
    powerplants_config = yaml.safe_load(file.read())


module module_powerplants:
    snakefile: github("modelblocks-org/module_powerplants", path="workflow/Snakefile", branch="main")
    config: powerplants_config
    pathvars:
        logs="resources/modules/powerplants/logs",
        resources="resources/modules/powerplants/resources",
        results="resources/modules/powerplants/results",
        shapes="resources/modules/geo_boundaries/results/{shapes}/shapes.parquet"

use rule * from module_powerplants as module_powerplants_*


