# This script creates initial and boundary conditions for BGC of ACCESS-OM2 at three resolutions

1. Everthing is done within the Jupyter Notebook `interpolate_to_access-om2.ipynb`.
1. This notebook should be run using `gadi_jupyter` by requesting the maximum memory for a whole node i.e., 192 GB.

## Directory structure

1. `input` contains input data.
1. `tmp` is where the regridded data will be stored initially. Delete this directory manually after regridding is finished successfully and the regridded data are moved to `*deg`.
1. `1deg`, `025deg`, `01deg` are where the regridded data are stored for each resolution.

## Data generated

The following files are generated in this notebook:

1. `bgc_param.nc` contains the BGC model parameters.
1. `co2_iaf.nc` and `co2_ryf.nc` contain the atmospheric CO2 concentrations for IAF and RYF.
1. `csiro_bgc.res.nc` contain the initial conditions.
1. `csiro_bgc_sediment.res.nc` contains the initial sediment conditions.
1. `dust.nc` contains the dust deposition for iron.

In addition, the following files need to be updated by adding extra coupling tracers for ice BGC:

`i2o.nc` contains initial conditions for ice-to-ocean coupling fields.
`o2i.nc` contains initial conditions for ocean-to-ice coupling fields.

## Details on the initial conditions

There are a few options for BGC initial conditions. The current version of this notebook supports generation of initial conditions either from:

1. `access-om2-1deg_omip2_cycle5` (adic,dic,alk)
1. `WOA13v2` (no3,o2; OMIP protocol)
1. `GLODAPv2 2016b` (no3,o2,adic,dic,alk)
1. `FeMIP median` (fe; mol L-1)
1. `0.01 mmol m-3` is given to phy,zoo,det,caco3.

Before regridding, input data are extrapolated over land to avoid missing values over the regridded ocean in case slight changes in the model bathymetry occurs in the future. This is done using `cdo fillmiss`.

WOMBAT wants these fields in the units of `mmol m-3` for all tracers except for iron (`umol m-3`). Therefore, appropriate unit conversion is needed if the input data are provided in different units.

