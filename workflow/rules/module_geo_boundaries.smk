"""The Modelblocks Geo-boundaries module.

This module specialises in creating high-resolution polygonal maps.
You can create multiple scenarios, each with a mix of different countries at
different (sub)national resolutions.

See the configuration file for more details.

Other resources:
- Code: https://github.com/modelblocks-org/module_geo_boundaries
- Overview: https://www.modelblocks.org/modules/module_geo_boundaries/
"""

# Load the configuration as a separate variable
with open(
    workflow.source_path("../../config/modules/geo_boundaries.yaml"), "r"
) as file:
    config_geo_boundaries = yaml.safe_load(file.read())


# Import and configure the module.
# You need internet access for this to work!
module module_geo_boundaries:
    # Pathvars can be used to "move" module inputs and outputs.
    # Each module has an INTERFACE.yaml file detailing available pathvars.
    pathvars:
        logs="resources/geo_boundaries/logs",
        resources="resources/geo_boundaries/resources",
        results="resources/geo_boundaries/results",
    # Request the latest version of the module.
    # Notice the pinned tag, which ensures stable version control within the project!
    snakefile:
        github(
            "modelblocks-org/module_geo_boundaries",
            path="workflow/Snakefile",
            tag="v1.0.2",
        )
    config:
        config_geo_boundaries


use rule * from module_geo_boundaries as module_geo_boundaries_*
