#!/bin/bash

if (( $(echo "$# == 0" | bc -l) )); then
	echo "you need to specifi for how long will the script run in the first argument"
	exit
fi

if (( $(echo "$# > 2" | bc -l) )); then
	echo "to many parameters"
	exit
fi

IFS=$'\n'
old=$(ps -eopid)

echo ----------------------------------------
echo " " > log.txt

while true; do
	now=$(ps -eopid)
	new=$(diff <(echo "$old") <(echo "$now") | grep ">")

	for l in $new; do
		pid=$(echo "$l" | grep -o [0-9]*)

		temp=$(ps -q $pid -o pid | wc -l)
		if (( $(echo "$temp != 2" | bc -l) )); then
			continue
		fi

		user=$(ps -q $pid -o user | grep -v USER)
		cmd=$(ps -q $pid -o cmd | grep -v CMD)
		ppid=$(ps -q $pid -o ppid | grep -o [0-9]*)
		pcmd=$(ps -q $ppid -o cmd | grep -v CMD)

		if (( $(echo "$# == 2" | bc -l) )); then
			temp=$(echo "$cmd" | grep "$2" | wc -c)
			if (( $(echo "$temp == 0" | bc -l) )); then
				continue
			fi
		fi

		echo "[+] New porcess"
		echo "USER: $user"
		echo "PPID: $ppid"
		echo " PID: $pid"
		echo " CMD: $cmd"
		echo "PCMD: $pcmd"
		echo ----------------------------------------

		echo "$pid,$user,$cmd,$ppid,$pcmd" >> log.txt
	done

	etime=$(ps -q $$ -o etimes | grep -o [0-9]*)
	if (( $(echo "$etime >= $1" | bc -l) )); then
		break
	fi
	old=$now
done
