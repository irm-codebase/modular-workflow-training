
with open(workflow.source_path("../../config/modules/geo_boundaries.yaml"), "r") as file:
    geo_boundaries_config = yaml.safe_load(file.read())


for scenario in geo_boundaries_config.keys():
    name = f"module_geo_boundaries_{scenario}"
    alias = name + "_"
    module:
        name: name
        config: geo_boundaries_config[scenario]
        snakefile: github("modelblocks-org/module_geo_boundaries", path="workflow/Snakefile", tag="v0.2.1")
        pathvars:
            logs=f"modules/geo_boundaries/{scenario}/logs",
            resources=f"modules/geo_boundaries/{scenario}/resources",
            results=f"modules/geo_boundaries/{scenario}/results",
    use rule * from name as alias*
