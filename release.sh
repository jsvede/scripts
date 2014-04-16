#!/bin/bash
#
# A script to stop tomcat, install the new versions
# of cms and cms-ui.
#
# Must be run as the tomcat user.
#

if [ $# -ne 1 ];
then
    echo "Usage: $0 [app version]"
    echo "       example: $0 1.0.1"
    echo "                This deploys version 1.0.1 of cms and cms-ui"
    exit
fi



sudo service tomcat7 stop

if [ $? -ne "0" ] ;
then
    echo "failed to shutdown tomcat cleanly. Exiting"
    exit
fi

release-deploy.sh cms $1
release-deploy.sh cms-ui $1
release-deploy.sh cpt $1

sudo service tomcat7 start

if [ $? -ne "0" ] ;
then
    echo "Unable to restart tomcat7. Check catalina.out and restart Tomcat"
    echo "  using sudo service tomcat7 start"
fi
