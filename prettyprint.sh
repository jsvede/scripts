#!/bin/bash

# A script to pretty print the XML in the headend
# files

if [ -d localized-hierarchy-defs ]
then
    cd localized-hierarchy-defs
fi

whereAreWe=$(pwd)

echo $whereAreWe

directories=$(ls)

echo found ${#directories[@]} with vod data

for dir in ${directories[@]}
do
	echo NOW IN $dir

	if [ -d $dir ]
	then
		cd $dir
	
		xmlFiles=$(ls *.xml)
		for xmlFile in $xmlFiles
		do
			mv "$xmlFile" "$xmlFile".tmp
			xmllint --format "$xmlFile".tmp > $xmlFile
			rm -rf "$xmlFile".tmp
		done

		cd ..
	fi
done

cd ..
