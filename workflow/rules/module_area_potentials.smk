"""The Modelblocks Area potentials module.

This module specialises in creating rasters with available renewable potential.
You can configure multiple cases per technology.

See the configuration file for more details.

Other resources:
- Code: https://github.com/modelblocks-org/module_area_potentials
- Overview: https://www.modelblocks.org/modules/module_area_potentials/
"""


with open(workflow.source_path("../../config/modules/area_potentials.yaml"), "r") as file:
    config_area_potentials = yaml.safe_load(file.read())

module module_area_potentials:
    snakefile: github("modelblocks-org/module_area_potentials", path="workflow/Snakefile", branch="v2.0.0")
    config: config_area_potentials
    pathvars:
        # Place files in a directory unique to this module...
        logs="resources/area_potentials/logs",
        resources="resources/area_potentials/resources",
        results="resources/area_potentials/results",

        # INPUTS
        # Our 'shapes' are the polygonal maps created by geo_boundaries
        shapes="resources/geo_boundaries/results/{shape}/shapes.parquet",
        wdpa="resources/downloads/WDPA_Sep2026_Public.gdb",

use rule * from module_area_potentials as module_area_potentials_*
