#!/bin/bash
#Dan Cosmin-Mihai, 312CA
old_process=$(ps -eo%p%U%c%P | grep -v "ps -eo%p%U%c%P"| grep -v "sleep 1" | grep -v "grep" | grep -v $(basename $0))
i=0
echo -n > log.txt
while [[ "$i" -lt "$1" ]];
do
 new_process=$(ps -eo%p%U%c%P | grep -v "ps" | grep -v "sleep 1" | grep -v "grep" | grep -v $(basename $0))
  diff_out=$(diff <(echo "$old_process") <(echo "$new_process") | grep [\<\>] | tr -d "<>")
  sw=0
  for k in $diff_out;
  do
  	sw=$((sw+1))
  	if [ "$sw" -eq 1 ]; then
  		echo "------------[+]New process detected----------------"
  		printf "| PID: %-42s |\n" "$k"
  		txtout="${k}"
  	fi
  	if [ "$sw" -eq 2 ]; then
  		printf "| User: %-41s |\n" "$k"
  		txtout="${txtout},$k"
  	fi
  	if [ "$sw" -eq 3 ]; then
  		printf "| CMD: %-42s |\n" "$k"
  		txtout="${txtout},$k"
  	fi
  	if [ "$sw" -eq 4 ]; then
  		printf "| PPID: %-41s |\n" "$k"
  		txtout="${txtout},$k"
  		if [ "$k" != "defunct" ]; then
  		 printf "| PCOM: %-41s |\n" "$(ps -p $k -o comm=)"
  		 txtout="${txtout},$(ps -p $k -o comm=)"
  		fi
  		echo "---------------------------------------------------"
  		sw=0
  		echo $txtout >> log.txt
  		txtout=""
  	fi
  done
  sleep 1
  old_process=$new_process
  i=$((i+1))
done
