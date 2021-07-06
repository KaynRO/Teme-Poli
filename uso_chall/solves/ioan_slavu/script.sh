#!/bin/bash

function get_cur_sec() {
	date +%s
}

duration=$1
CURSEC=`get_cur_sec`
quitpoint=`expr $CURSEC + $duration`
printf ' -%.0s' {1..20}
regex=$2

# Loop by line
IFS=$'\n'

old_process=$(ps aux | grep -v "ps aux" | grep -v "sleep 1" | grep -v $0)

while [ $CURSEC -lt $quitpoint ]; do
  	new_process=$(ps aux | grep -v "ps aux" | grep -v "sleep 1" | grep -v $0)
  	if [ "$regex" ]; then
	  	dif=$(diff <(echo "$old_process") <(echo "$new_process") | grep [\<\>] | grep "$regex" | tr -s ' ' | cut -c 3- )
	else
		dif=$(diff <(echo "$old_process") <(echo "$new_process") | grep [\<\>] | tr -s ' ' | cut -c 3- )
  	fi

  	#printf 'USER:%s' $ceva | cut -f1 -d ' ' 
 	#printf 'user:%s' $(($dif))
 	if [ "$dif" ]; then
 		for i in $(echo "$dif" | tr -s '')
 		do
			user=$(echo "$i" | cut -f1 -d " ")
 			pid=$(echo "$i" | cut -f2 -d " ")
 			cmd=$(echo "$i" | cut -f11 -d " ")
 			ppid=$(ps p"$pid" hoppid | tr -d " ")
 			pcmd=$(ps p"$ppid" hocomm)
 			if [[ $pcmd != *"systemd"* ]] && [[ $pcmd != *"kthreadd"* ]];then
	 			printf "\n[+] New Process started:\n"
	 			printf "USER: %s\n" $user
	 			printf "PID: %s\n" $pid
	 			printf "CMD: %s\n" $cmd
	 			printf "PPID: %s\n" $ppid
	 			printf "PCMD: %s\n" $pcmd 
				printf ' -%.0s' {1..20}
				output="${pid}, ${user}, ${cmd}, ${ppid}, ${pcmd}"
			fi
			echo "$output" >> log.txt
		done
	fi
	CURSEC=`get_cur_sec`
 	old_process=$new_process
  	sleep 1
done
printf '\n'
exit 0;