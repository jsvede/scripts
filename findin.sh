#!/bin/bash


if [ $# == 0 ] || [ $# != 3 ] 
then
	echo Usage: findin.sh location filePattern target
	echo         "example findin.sh . *.xml foo"
	exit 
fi


location=$PWD

if [ $1 != "." ]
then
	location=$1
fi


files=($(find $location -name "$2"))

echo found ${#files[@]} files that match "$2"

for file in ${files[@]}
do
	#echo "Examining $file"
	found=($(grep -n "$3" "$file"))
	if [ "" != "$found" ]; then
		echo "found $3 in file $file"
		echo "--------------------------------------------------------------------------"
		# for (( i=0; i<=$(( $total -1 )); i++ ))
		#for line in ${found[@]}
		
		total=${#found[*]}

		for (( i=0; i<=$(( $total -1 )); i++ ))
		do
			if [ $(($i%2)) -eq "0" ]
			then
				echo "line ${found[$i]} ${found[$i+1]}"
			fi
		done
		echo " "
	fi
done	

