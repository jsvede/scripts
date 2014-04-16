#!/bin/bash

# A shell script simplify deploying the CMS
# artifacts to tomcat7.#
#
# This script will:
#   o Remove the existing war files;
#   o Copy new war files from Artifactory;
#   o Verify that files are of non-zero length
#
# Relies on there the current user having read/write on
# the webapps and that they have a $TOMCAT_HOME variable
# set in their profile.
#
# This script probably needs to be run as the tomcat user, too.
#

# arguments
# [1] - project_name - the name of the project in artifactory
# [2] - version - which version of the files to deploy


PROJECT_NAME=$1
VERSION=$2


if [ $? -ne "0" ] ;
then
    echo "failed to shutdown tomcat cleanly. Exiting" 
    exit
fi

NEXUS_URL=http://nexusnpm.dev-charter.net/nexus/service/local/repositories/releases/content/com/charter/aesd/

cd $TOMCAT_HOME/webapps


echo "going to re-deploy $PROJECT_NAME.war"

if [ -e $PROJECT_NAME.war ];
then
    rm -rf $PROJECT_NAME.war
    rm -rf $PROJECT_NAME
fi

if [ -e $PROJECT_NAME.war ];
then
    echo "$PROJECT_NAME.war wasn't deleted - exiting"
	exit
else 
    echo "getting $PROJECT_NAME version " $VERSION
fi

wget -O $PROJECT_NAME.war $NEXUS_URL/$PROJECT_NAME/$VERSION/$PROJECT_NAME-$VERSION.war

if [ -e $PROJECT_NAME.war ];
then
	FILESIZE=$(stat -c%s "$PROJECT_NAME.war")

	if [ $FILESIZE -gt 0 ];
	then
        echo "SUCCESS: $PROJECT_NAME.war successfully installed"
	else 
		echo "ERROR: $PROJECT_NAME.war size = 0; exiting"
	fi
else 
    echo "failed to install $PROJECT_NAME.war - exiting"
    exit
fi


cd -

echo "installation complete"


