#!/usr/bin/env sh
module load nco

set -x
set -e

#Add sea-ice BGC tracers to the restart file and i2o.nc and o2i.nc.
#Below, you need to define 'path2restart' and 'filename' for the restart file.

#Define the path to the restart file you want to add BGC tracers
path2restart=/g/data/ik11/restarts/access-om2-01/01deg_jra55v140_iaf_cycle3/restart731

#Define the name of the restart file
filename=iced.2019-01-01-00000.nc

#Copy the restart file to pwd
cp ${path2restart}/ice/${filename} .

#Add 2D fields.
for j in algalN nit
do
	ncap2 -O -s ${j}=iceumask*0 ${filename} ${filename}
done

#Add 3D fields.
for j in bgc_N_sk bgc_Nit_sk
do
	ncap2 -O -s ${j}=aicen*0 ${filename} ${filename}
done

#Next i2o.nc and o2i.nc

filename=i2o.nc

#Copy the restart file to pwd
cp ${path2restart}/ice/${filename} .

for j in wnd10_io nit_io alg_io
do
    ncap2 -O -s ${j}=licefh_io*0 ${filename} ${filename}
done

filename=o2i.nc

#Copy the restart file to pwd
cp ${path2restart}/ice/${filename} .

for j in ssn_i ssalg_i
do
    ncap2 -O -s ${j}=sst_i*0 ${filename} ${filename}
done

# Also ocean_sbc.res.nc

filename=ocean_sbc.res.nc

#Copy the restart file to pwd
cp ${path2restart}/ocean/${filename} .

for j in n_surf alg_surf
do
    ncap2 -O -s ${j}=t_surf*0 ${filename} ${filename}
    for a in long_name units checksum
    do # remove attributes
        ncatted -O -a ${a},${j},d,, ${filename} ${filename}
    done
done
