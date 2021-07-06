#!/bin/bash

for ((j=1;j<=$1;j++))
do
    nrprocesses=$(ps -ef | wc -l)
    for ((i=2;i<=$nrprocesses+1;i++))
    do
        echo "====================" | tee -a log.txt
        user=$(ps -ef | sed -n "$i"p | sed 's/\( \)*/\1/g' | cut -d" " -f1)
        echo "USER:$user" | tee -a  log.txt
        echo "--------------------" | tee -a log.txt
        pid=$(ps -ef | sed -n "$i"p | sed 's/\( \)*/\1/g' | cut -d" " -f2)
        echo "PID:$pid" | tee -a log.txt
        echo "--------------------" | tee -a log.txt
        cmd=$(ps -ef | sed -n "$i"p | sed 's/\( \)*/\1/g' | cut -d" " -f8)
        echo "CMD:$cmd" | tee -a log.txt
        echo "--------------------" | tee -a  log.txt
        ppid=$(ps -ef | sed -n "$i"p | sed 's/\( \)*/\1/g' | cut -d" " -f3)
        echo "PPID:$ppid" | tee -a log.txt
        echo "--------------------" | tee -a log.txt
        pcmd=$(ps -ef | sed 's/\( \)*/\1/g' | cut -d" " -f1,2,8 | grep $ppid | cut -d" " -f3 | head -1)
        echo "PCMD:$pcmd" | tee -a log.txt
        echo "====================" | tee -a log.txt
    done
    sleep 1;
done
