#!/bin/bash

processes=()
end_time=$((SECONDS + $1))

rm log.txt 2> /dev/null
touch log.txt
echo "--------------------------------------"

for i in `ps -auxx | tr -s ' ' ' ' | cut -d ' ' -f2 | tail -n +2`
do
	if [ $i -ne $$ ]
	then
		processes+=($i)
	fi
done

while [ $SECONDS -lt $end_time ]
do
	for i in `ps -auxx | tr -s ' ' ' ' | cut -d ' ' -f2 | tail -n +2`
	do
		ok=1
		for id in ${processes[@]}
		do
			if [ $id -eq $i ]
			then
				ok=0
			fi
		done

		if ([ $ok -eq 1 ] && [[ `ps -p $i -o cmd` != 'CMD' ]] && [ $i -ne $$ ])
		then
			user=`ps -p $i -o user | tail -n 1 | sed 's/ //g'`
			ppid=`ps -p $i -o ppid | tail -n 1 | sed 's/ //g'`
			cmd=`ps -p $i -o cmd | tail -n 1`
			pcmd=`ps -p $ppid -o cmd | tail -n 1`

			if ([ -z $2 ] || ([ $2 != '' ] && [[ "$cmd" == *"$2"* ]] && [ "$cmd" != "$pcmd" ]))
			then
				echo "[+] New process started:"
				echo "USER: $user"
				echo "PID: $i"
				echo "CMD: $cmd"
				echo "PPID: $ppid"
				echo "PCMD: $pcmd"
				echo "--------------------------------------"
				processes+=($i)

				echo "$i,$user,$cmd,$ppid,$pcmd" >> log.txt
			fi
		fi
	done
done