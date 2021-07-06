#!/bin/bash

if test $# -gt 2 || test $# -lt 1 
then
    echo -e "Usage:\t $0 NR_OF_SECONDS [REGEX]\n"
    exit 1
fi

test -n $1 && test $1 -eq $1 &> /dev/null
if test $? -ne 0
then
    echo -e "First argument must be an integer"
    echo -e "Usage:\t $0 NR_OF_SECONDS [REGEX]\n"
    exit 1
fi

# verificarea corectitudinii argumentelor date scriptului
# in cazul unei erori se va afisa succint modul de folosire al acestuia 

runtime=$1 endtime=$(date -ud "$runtime"seconds +%s) 
initial_process=$(ps ax -o pid,user,ppid,cmd | grep -v "ps ax" | grep -v $0)
var=""

NC='\033[0m'
GR='\033[1;32;1;40m'
RED='\033[1;31;1;40m'
YL='\033[1;33;4m'
LC='\033[3;49;96m'

# declararea culorilor folosite pentru output si a variabilelor initiale

while test $(date -u +%s) -le $endtime; do

    new_process=$(ps ax -o pid,user,ppid,cmd | grep -v "ps ax" | grep -v $0)
    difr=$(diff <(echo "$initial_process") <(echo "$new_process") | grep [\<\>])
    while IFS= read -r line; do

        if [[ $line = \>* ]]; then

            pid=$(echo "$line" | tr -s ' ' | cut -d' ' -f2)
            user=$(echo "$line" | tr -s ' ' | cut -d' ' -f3)
            cmd=$(echo "$line" | tr -s ' ' | cut -d' ' -f 5-)
            ppid=$(echo "$line" | tr -s ' ' | cut -d' ' -f4)
            pcmd=$(echo -e "$initial_process\n$new_process" | grep "$ppid" | tr -s ' ' | cut -d' ' -f 5- | head -n 1)
            if [[ "$ppid" -ne "2" ]]
            then
                var="$var$pid,$user,$cmd,$ppid,$pcmd\n"
            fi
        fi
    done <<< $difr
    initial_process=$new_process

done

# salvarea datelor in formatul cerut intr-o variabila,
# pentru a putea fi sortate dupa regex

if test "$#" -eq 1; then
    (echo -e "$var" | sed '/^$/d') > log.txt
    if test "$?" -ne 0; then
        echo "Error: could not acces file log.txt"
        echo -e "Check permissions\n"
        echo -e ".....QUITING.....\n"
        exit 1
    fi
fi

if test "$#" -eq 2; then
    (echo -e "$var" | grep "$2" | sed '/^$/d') > log.txt
    if test "$?" -ne 0; then
        echo "Error: could not acces file log.txt"
        echo -e "Check permissions\n"
        echo -e ".....QUITTING....\n"
        exit 1
    fi
    (echo -e "$var" | grep -v "$2" | sed '/^$/d') >> log.txt
fi

# scrierea datelor in log.txt sortate sau nu, dupa numarul de argumente date scriptului

while IFS= read -r line; do

            test -z "$line" && continue

            echo -e "${GR}=====================================${NC}"
            echo -e "${YL}[+] New process started:${NC}"
            echo -en "${LC}USER:\t${NC} "
            echo "$line" | cut -d',' -f2

            echo -en "${LC}PID:\t${NC} "
            echo "$line" | cut -d',' -f1

            echo -en "${LC}COMMAND:${NC} "
            if test $# -eq 2 && echo "$line" | grep "$2" &> /dev/null
            then
                echo -e "\033[4;49;92m$(echo $line | cut -d',' -f3)${NC}"
            else
                echo "$line" | cut -d',' -f3
            fi

            echo -en "${LC}PPID:\t${NC} "
            echo "$line" | cut -d',' -f4

            echo -en "${LC}PCMD:\t${NC} "
            echo "$line" | cut -d',' -f5
            echo -e "${RED}=====================================${NC}"

            echo
            echo

done <<< $(cat log.txt | sed '/^$/d')

# afisarea proceselor, cele ale caror comanda a fost specificata prin regex fiind evidentiate

exit 0
