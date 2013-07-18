#!/bin/bash

# A script to pretty print the XML in the headend
# files

declare -a directories

if [ "$1" != "" ]
then
	directories=$(ls | grep $1)
else
	directories=$(ls)
fi

for dir in ${directories[@]}
do
	echo $dir: $( ls $dir | wc -l)
done

