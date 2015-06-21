**Author: Gautam Bisht** (<gbisht@lbl.gov>)

[TOC]

# Preparing Mac for ACME


1. Xcode
 - Download and install Xcode
 - Install Xcode command line developers tool by running the following command on terminal ```xcode-select --install``` and click on Install button
 - Launch Xcode and accept licence.


2. MacPorts
 - Download pkg for appropriate OS X from https://www.macports.org/install.php
 - Install the macports by double clicking on the *pkg and following on screen instructions.

3. Install softwares
  * gcc4.9:    

 ```
sudo port install gcc49
#
# Set soft links for gcc-mp-4.9/g++-mp-4.9/gfortran-mp-4.9 as
# gcc/g++/gfortran in /opt/local/bin
#
sudo ln -s /opt/local/bin/gcc-mp-4.9 /opt/local/bin/gcc
sudo ln -s /opt/local/bin/g++-mp-4.9 /opt/local/bin/g++
sudo ln -s /opt/local/bin/gfortran-mp-4.9 /opt/local/bin/gfortran
```

  * MPICH:

 ```
sudo port install mpich-gcc49
sudo port select --set mpi mpich-gcc49-fortran
 ```
  * HDF5:

 ```
sudo port install hdf5 +mpich +gcc49
 ```
  * NetCDF:    
 
 ```
 sudo port install netcdf-fortran +gcc49 +mpich
 ```
 
  * Git:       

 ```
sudo port install git
 ```

  * Mercurial: 

 ```
sudo port install mercurial
 ```

  * Perl:

 ```
sudo port install perl5
sudo port install p5.16-xml-libxml
 ```

  * CMake

 ```
sudo port install cmake
 ```

  * GMake

 ```
sudo port install gmake
 ```

<!---
  * Python:    

 ```
sudo port install python35
sudo port select --set python python35
 ```
-->

# Compiling an ACME case on Mac

- Checkout ACME

```
cd <project-directory>
git clone git@github.com:ACME-Climate/ACME.git

```

- Create a case for ACME

```
export RES=1x1_brazil
export COMPSET=ICLM45
export COMPILER=gnu
export MACH=mac

export CASE_NAME=${RES}.${COMPSET}.${COMPILER}

cd ACME/scripts

./create_newcase \
-case ${CASE_NAME} \
-compset ${COMPSET} \
-res ${RES} \
-compiler ${COMPILER} \
-mach ${MACH}

cd $CASE_NAME

```

- Modify env\_mach_pes.xmlodi

- Modify env\_build.xml

```
./xmlchange -file env_build.xml -id MPILIB -val mpich
./xmlchange -file env_build.xml -id OS -val Darwin
./xmlchange -file env_build.xml -id CESMSCRATCHROOT -val ${PWD}
./xmlchange -file env_build.xml -id EXEROOT -val ${PWD}/bld
```

- Modify env\_run.xml

```
./xmlchange -file env_run.xml -id DATM_CLMNCEP_YR_END -val 2000
./xmlchange -file env_run.xml -id DATM_CLMNCEP_YR_START -val 2000
./xmlchange -file env_run.xml -id DATM_CLMNCEP_YR_ALIGN -val 1
./xmlchange -file env_run.xml -id RUNDIR -val ${PWD}/run
```

- Do the setup

```
./cesm_setup
```

- Check that only a handful of files are missing.

```
>export DIN_LOC_ROOT=`./xmlquery DIN_LOC_ROOT | awk '{print $4}'`
>./check_input_data -inputdata ${DIN_LOC_ROOT} -check
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/lnd/clm2/snicardata/snicar_drdt_bst_fit_60_c070416.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/lnd/clm2/snicardata/snicar_optics_5bnd_c090915.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/lnd/clm2/surfdata_map/surfdata_1x1_brazil_simyr2000_c130927.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/share/domains/domain.clm/domain.lnd.1x1pt-brazil_navy.090715.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/lnd/clm2/paramdata/clm_params.c140423.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/cam/chem/trop_mozart/emis/megan21_emis_factors_c20120313.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/lnd/clm2/lai_streams/MODISPFTLAI_0.5x0.5_c140711.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/domain.T62.050609.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-01.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-02.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-03.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-04.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-05.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-06.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-07.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-08.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-09.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-10.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-11.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Solar6Hrly/clmforc.Qian.c2006.T62.Solr.2000-12.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/domain.T62.050609.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-01.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-02.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-03.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-04.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-05.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-06.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-07.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-08.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-09.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-10.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-11.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/Precip6Hrly/clmforc.Qian.c2006.T62.Prec.2000-12.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/domain.T62.050609.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-01.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-02.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-03.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-04.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-05.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-06.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-07.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-08.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-09.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-10.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-11.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/datm7/atm_forcing.datm7.Qian.T62.c080727/TmpPrsHumWnd3Hrly/clmforc.Qian.c2006.T62.TPQW.2000-12.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/cam/chem/trop_mozart_aero/aero/aerosoldep_monthly_2000_mean_1.9x2.5_c090421.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/atm/cam/chem/trop_mozart_aero/aero/aerosoldep_monthly_2000_mean_1.9x2.5_c090421.nc 
File is missing: /Users/gbisht/projects/acme/cesm-inputdata/share/domains/domain.clm/domain.lnd.1x1pt-brazil_navy.090715.nc 

```

- Export the missing file. (This is an optional step, because the missing files are automatically downloaded at 
the build stage.

```
>./check_input_data -inputdata ${DIN_LOC_ROOT} -export
```

- If need be, update compiler and netCDF settings in the ```Macros``` files

```
MPICC:= mpicc  
MPICXX:= mpicxx 
MPIFC:= mpif90 
SCC:= gcc 
SCXX:= g++ 
SFC:= gfortran 
NETCDF_PATH:= $(NETCDF_PATH)
```

- Build the case

```
>./${CASE_NAME}.build
```

- If need be, update ```mpirun``` in the ```${CASE_NAME}.run```.

- Run the case

```
>./${CASE_NAME}.run
```


