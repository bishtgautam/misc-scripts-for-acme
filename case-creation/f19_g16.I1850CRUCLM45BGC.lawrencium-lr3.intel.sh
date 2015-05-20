#!/bin/sh
# Author: Gautam Bisht <gbisht@lbl.gov>

display_usage(){
  echo >&2 \
  "usage: $0 [-a acme_src_dir | --acme_dir acme_source_dir] [-h|--help]"
}

acme_dir=

# Get command line arguments
if [  $# -le 1 ]
then
  display_usage
  exit 1
fi

while [ $# -gt 0 ]
do
  case "$1" in
    -a | --acme_dir ) acme_dir="$2"; shift;;
    -h | --help ) display_usage; exit 1;;
    -*) display_usage
      exit 1;;
    *)  break;;	# terminate while loop
  esac
  shift
done

# Check if ACME code directory is valid
if [ ! -d "$acme_dir/scripts" ]; then
  echo "ACME code directory does not exisit: " $acme_dir
  exit 1
fi

# Set other variables regarding the case
export RES=f19_g16
export COMPSET=I1850CRUCLM45BGC
export MAC=lawrencium-lr3
export COMPILER=intel
export CASE_NAME=${RES}.${COMPSET}.${MAC}.${COMPILER}.`date +"%Y-%m-%d-%H-%M-%S"`

cd ${acme_dir}/scripts

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

