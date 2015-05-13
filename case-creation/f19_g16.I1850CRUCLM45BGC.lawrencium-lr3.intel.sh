#!/bin/sh

export RES=f19_g16
export COMPSET=I1850CRUCLM45BGC
export MAC=lawrencium-lr3
export COMPILER=intel
export CASE_NAME=${RES}.${COMPSET}.${MAC}.${COMPILER}.`date +"%Y-%m-%d"`

./create_newcase -case ${CASE_NAME} -res ${RES} -compset ${COMPSET} -mach ${MAC} -project acme -compiler ${COMPILER}

cd $CASE_NAME

./xmlchange -file env_run.xml -id DIN_LOC_ROOT -val /clusterfs/esd/esd2/gbisht/ccsm_inputdata
./xmlchange -file env_run.xml -id DIN_LOC_ROOT_CLMFORC -val /clusterfs/esd/esd2/gbisht/ccsm_inputdata/atm/datm7
./xmlchange -file env_run.xml -id DATM_CLMNCEP_YR_END -val 1901

./cesm_setup

perl -w -i -p -e 's@#SBATCH --account=acme@#SBATCH --account=lr_esd2@' ${CASE_NAME}.run
perl -w -i -p -e 's@#SBATCH --qos=lr_normal@#SBATCH --qos=condo_esd2@' ${CASE_NAME}.run

./${CASE_NAME}.build

sbatch ${CASE_NAME}.run

