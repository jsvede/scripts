#!/bin/bash

# from 
# http://www.cyberciti.biz/faq/linux-random-password-generator/
genpasswd() {
        local l=$1
        [ "$l" == "" ] && l=16
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}


if [ $# != 1 ];
then
    echo Please supply a username.
    exit
fi

defaultPasswd=$(genpasswd 8)

sudo useradd $1 -p $defaultPasswd
sudo chage -d 0 $1

echo new user $1 created with default password $defaultPasswd