#!/bin/bash

folderName=$1
executable=$2

#find in the dir path the makefile 
cd "$folderName"
find . -name MakeFile
findMake=$?

if (($findMake>0)); then
	echo "Does not exist makefile, exit"
	exit 1;
fi;


#run the makefile
make 
sucssefullMake=$?



#run valgrind and change the deafult return value to be 1 if occurd an error
valgrind --tool=memcheck --leak-check=full --error-exitcode=1 ./"$executable" $@

valgrindReturn=$?
echo "valgrindReturn = " $valgrindReturn


#run helgrind for threads debug
valgrind --tool=helgrind ./"$executable" $@
helgrindReturn=$?
echo "helgrindReturn = " $helgrindReturn

#the return value of all the script will be:
# 0 if all the checks pass
# number between 1-7 if one of the checks failed
retVal=0;

if (($sucssefullMake>0)); then
	compilationAns="FAIL	"
	retVal+=4
else 
	compilationAns="PASS	"
fi;


if (($valgrindReturn>0)); then
	valgrindAns="FAIL	"
	retVal+=2
else 
	valgrindAns="PASS	"
fi;


if (($helgrindReturn>0)); then
	helgrindAns="FAIL"
	retVal+=1
else 
	helgrindAns="PASS"
fi;


echo "Compilation	Memory leaks	Thread race"
echo $compilationAns	$valgrindAns	$helgrindAns	

#echo $retVal
exit $retVal
