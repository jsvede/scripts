#!/bin/bash

# http://www.cyberciti.biz/faq/linux-random-password-generator/
genpasswd() {
        local l=$1
        [ "$l" == "" ] && l=16
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

if [ $# != 1 ];
then
    echo Please supply a username. An e-mail address optional.
    echo upreset.sh someone someone@charter.com
    exit
fi

EMAIL=$2

genPasswd=$(genpasswd 8)

echo $genPasswd | passwd $1 --stdin
sudo chage -d 0 $1

MESSAGE="/tmp/uaddmailmsg"

if [ -e $MESSAGE ];
then
    rm -rf $MESSAGE
fi

HOSTNAME=$(hostname)
IPADDR=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo "On hostname $HOSTNAME with IP address $IPADDR the password for user $1 has been reset to $genPasswd"> $MESSAGE

if [ "$2" != "" ];
then
    echo "Sending e-mail to $2"
    SUBJECT="Password rest for $1 on $HOSTNAME"
    /bin/mail -s "$SUBJECT" "$EMAIL" < $MESSAGE
    echo "Message sent."
fi

cat $MESSAGE

if [ -e $MESSAGE ];
then
    rm -rf $MESSAGE
fi