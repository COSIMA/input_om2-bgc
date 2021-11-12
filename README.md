# This script creates initial and boundary conditions for BGC in ACCESS-OM2 at three resolutions

1. For a cold start, everything is done within the Jupyter Notebook `interpolate_to_access-om2.ipynb`.
2. This notebook should be run using `gadi_jupyter` by requesting the maximum memory for a whole node i.e., 192 GB.
3. If adding BGC to an existing run, also edit and run `add_sea_ice_bgc_to_restart.sh` - see "Warm start" section below.
4. If you're happy with the results, you can run `finalise.sh` to commit any updates and include the git hash in the metadata of all .nc files.
 
## Directory structure

`interpolate_to_access-om2.ipynb` creates the following output directories in `basepath`:
1. `input` contains input data
2. `tmp` is where the regridded data will be stored initially. Delete this directory manually after regridding is finished successfully and the regridded data are moved to `*deg`.
3. `1deg`, `025deg`, `01deg` are where the regridded data are stored for each resolution.

## Data generated

The following files are generated in this notebook:

1. `bgc_param.nc` contains the BGC model parameters.
2. `co2_iaf.nc` and `co2_ryf.nc` contain the atmospheric CO2 concentrations for IAF and RYF.
3. `csiro_bgc.res.nc` contain the initial conditions.
4. `csiro_bgc_sediment.res.nc` contains the initial sediment conditions.
5. `dust.nc` contains the dust deposition for iron.

In addition, the following files need to be updated by adding extra coupling tracers for ice BGC:

6. `i2o.nc` contains initial conditions for ice-to-ocean coupling fields.
7. `o2i.nc` contains initial conditions for ocean-to-ice coupling fields.

## Details on the initial conditions

There are a few options for BGC initial conditions. The current version of this notebook supports generation of initial conditions either from:

1. `access-om2-1deg_omip2_cycle5` (adic,dic,alk). This is the restart file for the start of cycle 6 of omip2 (representative of 1958-01-01). This is used for 0.1deg-Cycle4. https://github.com/COSIMA/01deg_jra55_iaf/tree/01deg_jra55v140_iaf_cycle4
2. `WOA13v2` (no3,o2). This is the World Ocean Atlas 2013 version 2 (https://www.nodc.noaa.gov/OC5/woa13/woa13data.html).
3. `GLODAPv2 2016b` (no3,o2,adic,dic,alk). This is the The Global Ocean Data Analysis Project (GLODAP) version 2, 2016b, gap-filled product (https://www.glodap.info/index.php/mapped-data-product/).
4. `FeMIP median` (fe; mol L-1). This is the median values of multi-model output from FeMIP (http://omip-bgc.lsce.ipsl.fr/index.php/input-files/5-omip-bgc-initial-conditions). 
5. `0.01 mmol m-3` is given to phy,zoo,det,caco3.

Before regridding, input data are extrapolated over land to avoid missing values over the regridded ocean in case slight changes in the model bathymetry occurs in the future. This is done using `cdo fillmiss`.

WOMBAT wants these fields in the units of `mmol m-3` for all tracers except for iron (`umol m-3`). Therefore, appropriate unit conversion is needed if the input data are provided in different units.

### Default choice of the initial conditions for `master+bgc` branch of ACCESS-OM2

1. `GLODAPv2 2016b` for no3, o2, adic, dic, alk.
2. `FeMIP median` for fe.
3. `0.01 mmom m-3` for phy, zoo, det, caco3.

# Warm start: Add sea-ice BGC fields to the sea-ice restart file.
1. If your simulation uses warm start for physics, but cold start for BGC (such as https://github.com/COSIMA/01deg_jra55_iaf/tree/01deg_jra55v140_iaf_cycle4), you need to add initial fields for sea-ice BGC tracers to an existing restart file (e.g. `iced.2019-01-01-00000.nc`) and also sea-ice BGC coupling tracers to `i2o.nc` and `o2i.nc`.
2. This can be done by executing `add_sea_ice_bgc_to_restart.sh`. In this script, modify the path to and the name of the restart file.
