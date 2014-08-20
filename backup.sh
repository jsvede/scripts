#!/bin/bash

# A Script to stop the CMS cleanly and run a mysql back up. This script 
# Requires configuration on each system it is used. This script should work
# with Tomcat 6 or 7 as it uses a kill -15 to stop Tomcat.
#
# Use the following to sections to configur this script for your environment.
#
# This script checks to make sure we're running on Linux (this has to do with the
# availability of the pid file for tomcat, mostly). After this it calls the URL
# to stop the CMS loaders. Once that has returned it used the PID stored in the 
# /var/run/tomcatN/tomcatN.pid file to run the kill -15 on the process. Once the 
# process has stopped it will dump the database to the back up location. Next
# in removes the index/ and workspaces/ dirs from the jcr-repo/ dir. This helps
# to ensure that the indexes and workspaces are generated from the data in the db.
# Next it removes the temp/ dir and work/ directory contents to be save and then
# restarts tomcat.


#####################################################################################
##            S Y S T E M   S P E C I F I C    S E T T I N G S                     ##
#####################################################################################

# Tomcat Version - is either 6 or 7
VERSION=7

# Tomcat home directory; for most systems it's in /usr/share. Change as needed.
TC_HOME=/usr/share/tomcat$VERSION

# Standard location of the PID file for tomcat on Linux.
TOMCAT_PID_FILE=/var/run/tomcat$VERSION/tomcat$VERSION.pid 

# The location to which to write backups
DATABASE_BACKUP_LOCATION=$TC_HOME/db/backups


#####################################################################################
##                  D A T A B A S E   C O N F I G U R A T I O N                    ##
#####################################################################################

# database host or IP address 
DATABASE_HOST_NAME=172.30.210.173

# mysql database port; defaults to 3306
DATABASE_PORT=3306

# the database name to dump
DATABASE_NAME=cms

# the database user
DATABASE_USER_NAME=cms

# the users db password
DATABASE_PASSWORD=s3cret

osVersion=$(uname)

if [ ! $osVersion="Linux" ];
then
	echo "This only works on Linux systems, this system appears to be a $osVersion"
	exit
fi


if [ -e "$TOMCAT_PID_FILE" ];
then
	pid=$(head -n 1 $TOMCAT_PID_FILE)
	echo "Tomcat is running as PID $pid"

	stopLoaders=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' http://localhost:8080/cms/services/v1/mgmt/stopLoaders)	

	if [ $stopLoaders -ne 200 ];
	then
		echo "failed to stop loaders for CMS. HTTP status code was $stopLoaders. Exiting"
		exit -1
	fi

	echo "Loaders shut down. Stopping tomcat...."

	killTomcat=$(kill -15 $pid)

	if [[ "$killTomcat" -ne 0 ]];
	then
		echo "Tomcat did not stop. Return code is $killTomcat. Exiting"
		exit -2
	fi

else 
	echo "Tomcat is not running; continuing."
fi


echo "Tomcat shut down. Continuing to back up the database."

if [ ! -d $DATABASE_BACKUP_LOCATION ];
then
	createDir=$(mkdir -p $DATABASE_BACKUP_LOCATION)
	if [ "$createDir" -ne 0 ];
	then
		echo "Failed to locate back directory. Please manually create or verify permissions."
		exit -3
	fi
fi

dateTimeStamp=$(date +"%Y%m%d-%H%M%S")

runBackup=$(mysqldump -h $DATABASE_HOST_NAME -u $DATABASE_USER_NAME -p$DATABASE_PASSWORD $DATABASE_NAME > $DATABASE_BACKUP_LOCATION/$dateTimeStamp-$DATABASE_NAME-bakup.sql)

if [ ! -e $DATABASE_BACKUP_LOCATION/$dateTimeStamp-$DATABASE_NAME-bakup.sql ];
then
	echo "Database backup failed; back file $DATABASE_BACKUP_LOCATION/$dateTimeStamp-$DATABASE_NAME-bakup.sql does not exist. Exiting."
	exit -4
else 
	chown tomcat.tomcat $DATABASE_BACKUP_LOCATION/$dateTimeStamp-$DATABASE_NAME-bakup.sql
fi

echo "database backed up to $DATABASE_BACKUP_LOCATION/$dateTimeStamp-$DATABASE_NAME-bakup.sql"

$TC_HOME/ws-config/cms/
rm -rf index
if [ $? -eq 0 ];
then
        echo "Succesfully deleted index/ dir"
fi

rm -rf workspaces
if [ $? -eq 0 ];
then
        echo "Succesfully deleted workspaces/ dir"
fi

echo "Deleting work and temp directories"

cd $TC_HOME/work/
rm -rf *
if [ $? -eq 0 ];
then
        echo "Succesfully deleted contents of work/ dir"
fi

cd $TC_HOME/temp/
rm -rf *
if [ $? -eq 0 ];
then
        echo "Succesfully deleted contents of temp/ dir"
fi

echo "restarting tomcat$VERSION"

sleep 10

/etc/init.d/tomcat7 start

echo "Done"

exit 0
