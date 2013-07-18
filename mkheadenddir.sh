#!/bin/bash

# A script that creates a tmp dir, populates it
# and then timestamps it for the CMS loader process.

if [ $# -ne 2 ]
then
    echo $0 headEndName numFiles
    echo example: ./$0 alcoa 50
    exit
fi

if [ ! -d $1 ]
then
    echo $1 isn\'t a valid dir here
    exit
fi

filesInDir=($(ls $1))
echo there are ${#filesInDir[@]} for copying

now=$(date +"%Y%m%d-%H%M%S")

echo $now

echo making directory named 'renameMe' 
mkdir -p renameMe/$1

echo copy adi XML into renameMe dir
for (( c=1; c<=$2; c++ ))
do
    echo dir:  ${filesInDir[$c]}
    cp $1/${filesInDir[$c]} renameMe/$1/.
done

echo rename dir renameMe to $now
mv renameMe $now


fileCount=$(ls $now/$1 | wc -l)

echo moved $fileCount
