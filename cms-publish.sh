#!/bin/bash
# a script for running and scheduling CMS publish jobs from the crontab
# rather than with the built in quartz scheduling
#

function usage() {
        echo "Usage: $0 --config-id confidId --type [incremental|full]"
        echo "       example $0 --config-id 2 --type full"
        exit
}

function setup() {

    if [ $# -eq 0 ] || [ $# -lt 4 ]; then
        usage
    fi

    while [ "$1" != "" ]; do

        case $1 in
          -h | --help)
              usage
              exit
              ;;
          -c | --config-id)
              shift
              CONFIG_ID=$1
              ;;
          -t | --type)
              shift
              TYPE=$1
              ;;
          -d | --debug)
              shift
              DEBUG=true
              ;;
           --test)
              shift
              TEST_VALUE=true
              ;;
          *)
              echo "ERROR: unknown parameter \"$1\""
              usage
              exit 1
              ;;
        esac
        shift
    done
}

function validate() {
    if (( "$TYPE" != "incremental" || "$TYPE" != "full" ))
    then
        echo "Unknown type '$TYPE'. It must be set to 'full' or 'incremental'"
        exit
    else 
        echo "Going to run an '$TYPE' publish job for configId=$CONFIG_ID."
    fi
}


setup $@

validate

if [ "$TEST_VALUE" == "true" ]
then
    echo "TESTING SCRIPT"
    echo "good to go!"
    echo "Test complete. exiting."
    exit
exit
fi

curl --data "configId=$CONFIG_ID&publishType=$TYPE" http://localhost:8080/cms/services/v1/publisher/publish-content

echo ""
echo "done. exiting."
