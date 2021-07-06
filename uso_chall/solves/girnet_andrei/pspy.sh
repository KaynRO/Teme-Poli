#!/usr/bin/bash

rm log.txt

flags=()
flags_count=0

#Memorez flagurile
for argument in "$@"; do

    if [ "$argument" == "play" ];then

        #Totul merge mai bine cu o piesa
        paplay bg.wav &

    else

        flags+=( $argument )
        flags_count=$(( flags_count + 1 ))

    fi

done

#vezi daca nu e cifra
if (( flags[0] > 0 )); then
        
    #daca e cifra fa ceva fara sa aibi valoare
    x=1

else
    
    #daca e comanda da nu cifra
    flags+=( ${flags[0]} )
    flags_count=$(( flags_count + 1 ))

    #Daca nu s-a introdus timpul pentru care se ruleaza, timpul devine infinit
    flags[0]='infinity'

fi

clear

if (( $flags_count == 2 )); then
       
    comand="true"

else

    comand="false"

fi

if (( "${flags[0]}" != "infinity" )); then
    
    echo -e "\e[1;31mMonitorizarea Proceselor timp de \e[1;33m${flags[0]}\e[0m \e[1;31msecunde a pornit\e[0m \e[1;32m;)\e[0m" 

else

    echo -e "\e[1;41m(^_^) Nu ai introdus timpul pentru monitorizare, dar e ok, nu-ti fa griji\e[0m"

fi

#daca sa introdus o comanda care sa fie urmarita
if [ "$comand" = "true" ]; then
       
    echo -e "La moment cuvintul chee e \e[1;32m${flags[1]}\e[0m"
    
else

    #daca nu comanda chee va fi "."
    flags[1]="."

fi

hh=$( date|cut -d " " -f1,2,3,4,5 )
echo ${hh^}

#informatii din /proc/loadavg
load_aver=$( cut -d " " -f1 /proc/loadavg )
echo -e "\e[1;42m#Load average pentru ultima minuta:\e[0m \e[1;5m$load_aver\e[0m"
load_aver=$( cut -d " " -f2 /proc/loadavg )
echo -e "\e[1;43m#Load average pentru ultimele 5 minute:\e[0m \e[1;5m$load_aver\e[0m"
load_aver=$( cut -d " " -f3 /proc/loadavg )
echo -e "\e[1;44m#Load average pentru ultimele 15 minute:\e[0m \e[1;5m$load_aver\e[0m"

x=$( cat /proc/loadavg | grep -oh "\w*/" )
echo -e "La moment, \e[1;34mruleaza\e[0m sau sunt \e[1;34mgata de rulare\e[0m \e[4m${x::-1} procese\e[24m"

x=$( cat /proc/loadavg | grep -oh "/\w*" )
echo -e "In \e[1;34mtotal\e[0m sunt \e[4m${x:1} procese\e[24m" 

#contorizarea timpului
sleep ${flags[0]} &

#memorez ultimul pid trimis in background
last_pid=$! 

#afisarea liniei de sus
echo "PID,USER_NAME,COMAND,PARENT_PID,PARENT_COMAND">>log.txt

while ( ps --pid=$! > /dev/null ); do

    for ps_pid in $( ps -e -o pid= |tail -n 5 ); do

        if [ $last_pid -lt $ps_pid ] && ( [ "${flags[1]}" == "." ] || ( ps -p $ps_pid -o comm= | grep  "${flags[1]}" >/dev/null) );then
            
            #in caz ca procesul a fost prea rapid pentru ai prinde toate datele
            #si pentru a nu avea iesiri doar a pidului, fara alti parametri
            if ( ps -p $ps_pid -o uname= > /dev/null ); then

                #deoarece e mare posibilitatea ca pina voi afisa 1-2 parametri procesul va disparea
                #memorez in variabile parametrii doriti 
                ppid=$(ps -p $ps_pid -o ppid= |sed -r 's/ //g')
                pcomm=$( ( ps -p $ppid -o cmd= ) 2> /dev/null )
                uname=$( ps -p $ps_pid -o uname= )
                uid=$(ps -p $ps_pid -o uid= |sed -r 's/ //g')
                comm=$(ps -p $ps_pid -o cmd= );
               
               if [[ $pcomm != "[kthreadd]" ]] && [[ $pcomm != "/lib/systemd/systemd-udevd" ]];then
                    echo "/----------------------------/"
                    echo -e "\e[1;41m\e[5m{+}\e[25mNew Proces Created\e[0m"
                    echo
                    echo -e "    \e[1;32mUSER NAME:\e[0m $uname"
                    echo -e "    \e[1;32mUSER ID:\e[0m $uid"
                    echo -e "    \e[1;32mPROCES NAME:\e[0m $comm"
                    echo -e "    \e[1;32mPARENT PROCES NAME:\e[0m $pcomm"
                    echo -e "    \e[1;32mPARENT PROCES ID:\e[0m $ppid"
                    echo -e "    \e[1;32mPROCES ID:\e[0m $ps_pid"
                    echo -e "    \e[1;32mPROCES START TIME:\e[0m $(date |cut -d " " -f5)"
                fi
                echo "$ps_pid,$uname,$comm,$ppid,$pcomm" >> log.txt
                
                last_pid=$ps_pid

            fi

        fi

    done

done

killall paplay 2> /dev/null

#made by Andrei Girnet 311CB with LOVE
