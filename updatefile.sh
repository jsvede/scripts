#!/bin/bash

# A shell script simplify deploying the CMS
# artifacts to tomcat7.#
#
# This script will:
#   o Remove the existing files;
#   o Copy new file from Artifactory;
#   o Verify that file is of non-zero length
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
# [3] - artifact name

PROJECT_NAME=$1
VERSION=$2
ARTIFACT_NAME=$3


if [ $3 -ne "3" ] ;
then
    echo "$0 requires 3 arguments: project_name artifact_version artifact_name" 
    exit
fi

NEXUS_URL=http://nexusnpm.dev-charter.net/nexus/service/local/repositories/releases/content/com/charter/aesd/

cd $TOMCAT_HOME/ws-config/$PROJECT_NAME


echo "going to install $ARTIFACT_NAME"

if [ -e $ARTIFACT_NAME ];
then
    rm -rf $ARTIFACT_NAME
fi

if [ -e $ARTIFACT_NAME ];
then
    echo "$ARTIFACT_NAME wasn't deleted - exiting"
	exit
else 
    echo "getting $ARTIFACT_NAME version " $VERSION
fi

wget -O $ARTIFACT_NAME $NEXUS_URL/$PROJECT_NAME/$VERSION/$PROJECT_NAME-$VERSION-$ARTIFACT_NAME

if [ -e $ARTIFACT_NAME ];
then
	FILESIZE=$(stat -c%s "$ARTIFACT_NAME")

	if [ $FILESIZE -gt 0 ];
	then
        echo "SUCCESS: $ARTIFACT_NAME successfully installed"
	else 
		echo "ERROR: $ARTIFACT_NAME size = 0; exiting"
	fi
else 
    echo "failed to install $ARTIFACT_NAME - exiting"
    exit
fi
	
echo "installation complete"


