#!/bin/bash

# A script to cd into each dir, run mvn eclipse:clean so that 
# stupid eclipse will stop complaining about classpath variables.
#
#http://stackoverflow.com/questions/10564684/how-to-fix-error-updating-maven-project-unsupported-iclasspathentry-kind-4
#

originalDir=$PWD

cd $WS_MAIN_HOME

files=$(ls -d */)

declare -a arr=($files)


# For each directory, cd into and check for the existence of a pom
# if a pom file exists then execute the command, else continue
for file in ${arr[@]} ; do 
    if [[ -d $file ]]; then
	echo "cd into dir $file"
	cd $file
        if [[ -e "pom.xml" ]]; then
	    mvn eclipse:eclipse
        fi
	cd .. 
     else 
	echo "$file isn't dir"
     fi
done

cd $originalDir
