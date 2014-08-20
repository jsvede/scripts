#!/bin/bash

# Do a full clean up with a new repo
VERSION=7
TC_HOME=/usr/share/tomcat$VERSION
tomcatPidFile=/var/run/tomcat$VERSION/tomcat$VERSION.pid 

echo $tomcatPidFile
if [ -e "$tomcatPidFile" ];
then
	echo "Tomcat PID file exists; is tomcat running? ($tomcatPidFile)"
	pid=$(read -r FIRSTLINE < filename)
	echo "Exiting(pid = $pid)."
	exit
else
	echo "Tomcat is not running; continuing."
fi

echo "Do want to drop the database tables [y/n]"
read deleteTables

if [ "$deleteTables" = "y" ]; 
then
	echo "Database host (name or ip):"
	read dbHost
	
	echo "Database username:"
	read dbUserName
	
	echo "Database name:"
	read dbName
  
  echo "Database password"
  read dbPassword
	
	echo "Going to drop tables for db $dbName using user $dbUserName on host $dbHost[y/n]"
	read goNoGo
	
	if [ "$goNoGo" = "y" ];
	then
		mysql -h $dbHost -u $dbUserName -p $dbName --password=$dbPassword < dropJcrTables.sql
	fi 
fi



echo "Deleting workspaces and index directories"
cd $TC_HOME/ws-config/cms/jcr-repo

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
	echo "Succesfully deleted work/ dir"
fi

cd $TC_HOME/temp/
rm -rf *
if [ $? -eq 0 ];
then
	echo "Succesfully deleted temp/ dir"
fi

