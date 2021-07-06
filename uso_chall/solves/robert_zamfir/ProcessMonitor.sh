
rm log.txt
rm filtred_process
echo "Dati durata de monitorizare in secunde: "
read duration
beggin=$(date +%s)
current=$(date +%s)
period_passed=`expr $current - $beggin`

old_process=$(ps -eo pid,user,cmd,ppid | grep -v "$$!")

while test "$period_passed" -le "$duration"
do
	new_process=$(ps -eo pid,user,cmd,ppid)
	
	# urmatoarele 2 linii sunt necesare daca vrem sa nu se vada procesele create de script in sine
	n="$(echo "$new_process"| grep -n -m1 "ps -eo pid,user,cmd,ppid" | cut -d':' -f1)"
	new_process="$(echo "$new_process" | sed "$n d")"					
	new_activated_process="$(diff <(echo "$old_process") <(echo "$new_process") | grep [\>])"
	
	old_process="$new_process"

	new_activated_process="$(echo "$new_activated_process" | sed -r 's/^> *//' | sed -r 's/ +/;/' | sed -r 's/ +/;/'  | sed -r 's/ +([0-9]+)$/;\1/')"
	
	k=1
	for i in $(echo "$new_activated_process" | rev | cut -d';' -f1 | rev)
	do 
		parent_process="$(echo "$new_process" | grep -m1 "$i" | sed -r 's/^ +//' | sed -r 's/ +/;/2'| sed -r 's/ +([0-9]+)$/;\1/'| rev | cut -d';' -f2 | rev | sed 's/\//\\\//g')"
		new_activated_process="$(echo "$new_activated_process" | sed "$k s/$/;$parent_process/")"
		if [[ "$new_activated_process" != *"kworker"* ]]
		then
			echo "PID: $(echo "$new_activated_process" | nawk NR=="$k" | cut -d';' -f1)"
			echo "USER: $(echo "$new_activated_process" | nawk NR=="$k" | cut -d';' -f2)"
			echo "CMD: $(echo "$new_activated_process" | nawk NR=="$k" | cut -d';' -f3)"
			echo "PPID: $(echo "$new_activated_process" | nawk NR=="$k" | cut -d';' -f4)"
			echo "PCMD: $(echo "$new_activated_process" | nawk NR=="$k" | cut -d';' -f5)"
			echo -e "\n"
			k=$((k+1))
		fi
	done
	
	if [ ! -z "$new_activated_process"  ]
	then
		echo "$new_activated_process" >> log.txt
	fi
	
	current=$(date +%s)
	period_passed=`expr $current - $beggin`
done

echo "Dati valoare filtru: "
read filtru
grep -E "[0-9]+;.*;"$filtru";[0-9]+;.*" log.txt > filtred_process

sed -i 's/;/,/g' log.txt


