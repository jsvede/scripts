#!/bin/bash

if [ -d allendale ];
then
    mkdir allendale
fi

if [ -d medford ];
then
    mkdir medford
fi

if [ -d jackson ];
then
    mkdir jackson
fi

if [ -d reno ];
then
    mkdir remo
fi


cp ~jsvede/tmp/allendale/* allendale/.
cp ~jsvede/tmp/medford/* medford/.
cp ~jsvede/tmp/jackson/* jackson/.
cp ~jsvede/tmp/reno/* reno/.

