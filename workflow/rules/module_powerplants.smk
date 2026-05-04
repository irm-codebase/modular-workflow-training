
with open(workflow.source_path("../../config/modules/powerplants.yaml"), "r") as file:
    powerplants_config = yaml.safe_load(file.read())


module module_powerplants:
    snakefile: github("modelblocks-org/module_powerplants", path="workflow/Snakefile", branch="main")
    config: powerplants_config
    pathvars:
        logs="modules/powerplants/logs",
        resources="modules/powerplants/resources",
        results="modules/powerplants/results",
        shapes="modules/geo_boundaries/{shapes}/results/shapes.parquet"

use rule * from module_powerplants as module_powerplants_*


