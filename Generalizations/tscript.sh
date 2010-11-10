#!/bin/bash



helpOpt()
{
  echo "Usage: $0 -a1 -a2 -i -o -l -t"
  echo "Example: $0 ../tscript.sh -p 1 -a a.out -b a.out -i ../../../Data/parts/3/ -o Log10/3 -l 10 -t 1 |tee -a err.log"
  echo "Options: These are optional arguments"
  echo " -a progname_single"
  echo " -b progname_parallel"
  echo " -i input"
  echo " -o outputdir"
  echo " -l loop_times"
  echo " -p problem_type, 0=classic (not supported yet), 1=bcp, 2=mcp, 3=bmcp"
  echo " -t run_type, use 3 "
  echo " they will override the default values"
  exit 1
}
myProgNameS="a.single.out"
myProgNameP="a.parallel.out"
myProgType=1
myInput=""
myOutput="log_dir/"
myLoopTimes=100
myRunThreads=1 #default  , 1 thread (single)

#
#if no argument
#
if [ $# -lt 1 ]; then
  helpOpt
fi

while getopts p:a:b:i:o:l:t:s opt
do
  case "$opt" in
    p) myProgType="$OPTARG";;
    a) myProgNameS="$OPTARG";;
    b) myProgNameP="$OPTARG";;
    i) myInput="$OPTARG";;
    o) myOutput="$OPTARG";;
    l) myLoopTimes="$OPTARG";;
    t) myRunThreads="$OPTARG";;
	s) dummy=1;;
    \?) helpOpt;;
  esac
done

echo "progType: $myProgType, progNameS: $myProgNameS, progNameP: $myProgNameP"
echo "input: $myInput, output: $myOutput"
echo "loop: $myLoopTimes, numthreads: $myRunThreads";


exec_cmd(){
	cmdName=$1
	gFile=$2  #graph file
	lfile=$3 #logfile
	nthreads=$4
	pType=$5

	#echo log:$lfile threads:$nthreads progname:$cmdName input:$gFile
	for ((iter = 1 ; iter <= myLoopTimes ; ++iter))
	  do
	  #echo -n "$iter " >> $lfile
	  OMP_NUM_THREADS=$nthreads; /usr/bin/time -f"%e" -ao $lfile  ./$cmdName $gFile  $pType >> $lfile ; sleep 1 ; 
	done
}


#numthreads=0
r_run(){
	numthreads=$1

	fname=$myLOGdir`basename $singlefile`_`date '+%s'`.log

	fullPathS=`pwd`/$myProgNameS;
	fullPathP=`pwd`/$myProgNameP;

	echo "Running $singlefile for $myLoopTimes times, logged to $fname";	

	echo `basename $singlefile`  n_loops: $myLoopTimes>> $fname n_threads: $numthreads
	echo `date`" "`pwd`/$fname >> $fname



	echo "Single w/ #threads: 1";

	echo "Single "`md5sum $fullPathS` >> $fname
	exec_cmd $myProgNameS $singlefile $fname 1 $myProgType

	
	if [ $numthreads -gt 1 ]
		then
		echo -n "Parallel w/ #threads: "
		for ((i = 2 ; i <=numthreads  ; i+=3))
		  do
		  echo -n "$i ";
		  echo "Parallel $i "`md5sum $fullPathP` >> $fname
		  exec_cmd $myProgNameP $singlefile $fname i $myProgType
		done
	fi
	echo ""
	echo "done -> $fname";
	
}



myLOGdir=$myOutput/`date '+%s'`/

if [ ! -e "$myLOGdir" ] 
	then
	mkdir -p $myLOGdir
fi


if [ -d "$myInput" ] #it's a dir
	then
	for singlefile in $myInput/*.col
	  do
#	  if [ "${singlefile##*.}" = "b" ]  
#		  then
		  r_run $myRunThreads
#		  else
#		  echo skipping $singlefile
#	  fi
	  echo ""
	done
	
	echo "Done all!"
else #it's a file
	singlefile=$myInput
	r_run $myRunThreads
fi

		

	
	


#	if [ "${2##*.}" = "b" ] 

