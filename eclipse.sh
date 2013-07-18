#!/bin/bash

# Simple script to centralize the starting of extra Eclipse instances
       
# echo args: $0 $1 $2 $3

eclipseDir=~/eclipse

if [ -z $1 ] 
then                          
	versions=`ls $eclipseDir`
	echo "specify an Eclipse instance to start:"
	for version in $versions  
	do
	 	echo $version
	done
	exit
fi 
                
directory=$eclipseDir/$1/eclipse/Eclipse.app/Contents/MacOS

if [ -e $directory ]
then
	cd $directory
	nohup ./eclipse $2 $3& > eclipse.out 2>&1
else
	eclipseDir=~/personal/eclipse
 	directory=$eclipseDir/$1/eclipse/Eclipse.app/Contents/MacOS
	echo $directory
	if [ -e $directory ]
	then
		cd $directory
		nohup ./eclipse $2 $3& > eclipse.out 2>&1
	else
	 echo "no such eclipse version found on this system ($1)"
	fi
fi

