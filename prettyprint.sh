#!/bin/bash

# A script to pretty print the XML in the headend
# files

cd localized-hierarchy-defs

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
			rm -rf "$XmlFile".tmp
		done

		cd ..
	fi
done

cd ..
