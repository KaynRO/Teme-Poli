#!/bin/bash

  start=$SECONDS;
  pid=-1;
  shell_pid=$$;
  counter=0;

  echo -e 'NEW SCRIPT RUN:\n' >> log.txt
  while [ $(($SECONDS-$start)) -lt $1 ]
     do
        user=`ps -eo user --sort=-start_time | head -7 | tail -1 | grep -v "tail\|head\|ps\|grep"`;
        process_pid=`ps -eo pid --sort=-start_time | head -7 | tail -1 | grep -v "tail\|head\|ps\|grep"`;
        cmd=`ps -eo cmd --sort=-start_time | head -7 | tail -1 | grep -v "tail\|head\|ps\|grep"`;
        ppid=`ps -eo ppid --sort=-start_time | head -7 | tail -1 | grep -v "tail\|head\|ps\|grep"`;
        pcmd=`ps --pid $ppid -o cmd | tail -1`;
        process_time=`ps -eo etimes --sort=-start_time | head -7 | tail -1 | grep -v "tail\|head\|ps\|grep"`;

        if [ ! -z "$2" ]
            then
                cmd_grepped=`ps -eo cmd --sort=-start_time | head -8 | tail -1 | grep $2 | grep -v "tail\|head\|ps\|grep"`;
            else
                cmd_grepped=1;
        fi

        if [ "$process_pid" -ne "$pid" ] && [ "$process_pid" -ne "$shell_pid" ] && [ ! -z "$cmd_grepped" ] && [ "$process_time" -le $SECONDS ];
               then
                    echo "[+] New process started:"
                    echo "USER: $user";
                    echo "PID: "$process_pid | xargs;
                    echo "CMD: $cmd";
                    echo "PPID: "$ppid | xargs;
                    echo "PCMD: $pcmd";
                    pid=$process_pid; 
                    echo '----------------------------------------';
                    counter=$((counter+1));
                    echo "$counter. USER: $user, " "PID: $pid, " "CMD: $cmd, " "PPID: $ppid, " "PCMD: $pcmd" >> log.txt;
        fi
     done
  exit

