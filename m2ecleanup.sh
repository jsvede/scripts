#!/bin/bash

# A script to cd into each dir, run mvn eclipse:clean and then 
# mvn eclipse:eclipse so that eclipse will stop complaining 
# about classpath variables. This is a known issue in the m2e
# plugin, you can read about that here:
#
# https://bugs.eclipse.org/bugs/show_bug.cgi?id=394042
#
# And although the bug says you shouldn't need to rely on 
# stackoverflow, ya do:
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
	    mvn eclipse:clean
	fi
	cd .. 
     else 
	echo "$file isn't dir"
     fi
done

cd $originalDir
