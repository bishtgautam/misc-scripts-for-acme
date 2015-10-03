#!/bin/sh


acme_dir=
grid_file=
res_name=
grid_type=global
run_dir=./
queue=regular
walltime=04:00:00
mach=edison

# Get command line arguments
while [ $# -gt 0 ]
do
  case "$1" in
    -a | --acme_dir   ) acme_dir="$2";  shift;;
    -g | --grid_file  ) grid_file="$2"; shift;;
    -t | --grid_type  ) grid_type="$2"; shift;;
    -r | --run_dir    ) run_dir="$2";   shift;;
    -q | --queue      ) queue="$2";     shift;;
    -w | --walltime   ) walltime="$2";  shift;;
    --res_name        ) res_name="$2";  shift;;
    -*) echo >&2 \
      "usage: $0 [-a|--acme_dir] <dir> [-g|--grid_file] <file.nc> [-t|--grid_type] <regional/global>" \
      " [-r|--run_dir] <dir> [-q] <debug/regular> [-w|--walltime] <hh:mm:ss> --res_name <name>"
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

# Check if run directory is valid
if [ ! -d "$run_dir" ]; then
  echo "Run directory does not exisit: " $run_dir
  exit 1
fi

# Check if the grid file exists
if [ ! -f "$grid_file" ]; then
  echo "Grid file directory does not exisit: " $grid_file
  exit 1
fi

# Check if test category is valid
case "$queue" in
  "debug")
    walltime=00:30:00
    ;;
  "regular")
    ;;
  *)
    echo "Following queue is not valid: " $queue
    exit 1
    ;;
esac

# Check if res_name is specified
if [ "$res_name" == "" ]; then
  echo "-res_name option needs to be specified"
  exit
fi

# Check if running on Edison
mach=`echo $HOST | cut -c1-6`

case "$mach" in
  "edison")
     module load nco/4.3.8
     module load ncl/6.1.1
     module load /global/project/projectdirs/ccsm1/modulefiles/edison/esmf/6.3.0rp1-ncdfio-mpi-O
     export ESMFBIN_PATH=/project/projectdirs/ccsm1/esmf/edison/ESMF-6.3.0rp1intel14.0_netcdf4.1.3-O/bin
     export REGRID_PROC=48
     export MPIEXEC="aprun -n ${REGRID_PROC} "
     export CSMDATA=/project/projectdirs/ccsm1/inputdata
     ;;
   *)
    echo "Following machine is not supported: " $mach
    exit 1
   ;;
esac

pwd=$PWD

cd ${acme_dir}/models/lnd/clm/tools/shared/mkmapdata

./mkmapdata.sh           \
--gridfile ${grid_file}  \
--res      ${res_name}   \
--phys     clm4_5        \
--gridtype ${grid_type}  \
--debug                  \
--batch                  \
-v 2>&1 | tee mkmapdata.log

cat mkmapdata.log | \
grep -v queryDefaultNamelist.pl | \
grep -v 'Script to create' | \
grep -v 'Succ' | \
grep -v 'From input grid' | \
grep -v 'For output' | \
grep -v 'Using user' | \
grep -v 'Output grid resolution ' | \
grep -v './mkmapdata.sh' | \
grep -v 'PET' | \
grep -v 'which' | \
grep -v 'Running ' | \
grep -v 'Creating ' > ${pwd}/mkmapdata.commands

cd ${pwd}

sed -e '/^[[:blank:]]*$/d'  mkmapdata.commands  > mkmapdata.commands.2
mv mkmapdata.commands.2 mkmapdata.commands

CDATE="c"`date +%y%m%d`
sed -i "s/${CDATE}/\${CDATE}/g" mkmapdata.commands

QUEUE=debug
WALLTIME=00:30:00

for ii in {1..15}; 
do 

  if [ "$ii" -lt 10 ] 
  then
    map_id=0${ii}
  else
    map_id=${ii}
  fi 

  filename=${res_name}.map_${map_id}.pbs
  rm -f ${filename}

  cat >> ${filename} << EOF
#PBS -A acme
#PBS -q ${QUEUE}
#PBS -l mppwidth=48
#PBS -l walltime=${WALLTIME}
#PBS -N ${res_name}.map_${map_id}
#PBS -j oe 
#PBS -m abe
#PBS -M gbisht@lbl.gov

module load nco/4.3.8
module load ncl/6.1.1

cd $RUNDIR

CDATE="c"\`date +%y%m%d\`

EOF

  head -$((ii*6)) mkmapdata.commands  | tail -6 >> ${filename}

  hydro1k_pbs=`cat ${filename}  | grep HYDRO1K | wc -l`
  if [ $hydro1k_pbs -gt 0 ]
  then
    perl -w -i -p -e 's@mppwidth=48@mppwidth=960@' ${filename}
    perl -w -i -p -e 's@aprun -n 48@ aprun -n 48 -S 1@' ${filename}
    perl -w -i -p -e 's@--netcdf4@--64bit_offset@' ${filename}
  fi

done

