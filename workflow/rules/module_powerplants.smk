"""Modelblocks Powerplants module.

This module cleans up powerplant data from the Global Energy Monitor (GEM) project.
Eight different powerplant categories are supported:
 - bioenergy, fossil, geothermal, hydropower, nuclear, large_solar, solar, and wind.

See the configuration file for more details.

Other resources:
- Code: https://github.com/modelblocks-org/module_powerplants
- Overview: https://www.modelblocks.org/modules/module_powerplants
"""

with open(workflow.source_path("../../config/modules/powerplants.yaml"), "r") as file:
    config_powerplants = yaml.safe_load(file.read())

# As before, you need internet access to run this!
module module_powerplants:
    snakefile: github("modelblocks-org/module_powerplants", path="workflow/Snakefile", branch="fix/map-exploration")
    config: config_powerplants
    pathvars:
        # Place files in a directory unique to this module...
        logs="resources/powerplants/logs",
        resources="resources/powerplants/resources",
        results="resources/powerplants/results",

        # INPUTS
        # Our 'shapes' are the polygonal maps created by geo_boundaries
        shapes="resources/geo_boundaries/results/{shapes}/shapes.parquet"
        # Rootop PV needs a proxy raster to estimate its distribution...
        # proxy_rooftop_pv=

use rule * from module_powerplants as module_powerplants_*
