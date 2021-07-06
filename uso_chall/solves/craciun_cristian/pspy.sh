#!/bin/bash

# VARIABLES

working_path="./"
working_dir="PSPY"
tmp_dir="TMP"
tmp_name="tmp_file"
err_name="errors"
psf_name="ps_file"
log_name="log.txt"
n_name="new_ps"
ps_file="${working_path}${working_dir}/${tmp_dir}/${psf_name}"
tmp_file="${working_path}${working_dir}/${tmp_dir}/${tmp_name}"
new_ps="${working_path}${working_dir}/${tmp_dir}/${n_name}"
err_file="${working_path}${working_dir}/${err_name}"
log_file="${working_path}${working_dir}/${log_name}"

directories="/usr /tmp /dev /opt /home"

format_ps="user,pid,ppid,cmd"

nr=1

# INIT COMMANDS



echo "Checking dependencies...!";
echo "-----------------------------------------------------------------------------------";
echo "";

which inotifywait &> /dev/null || sudo apt install inotify-tools;

clear;
echo "All good!";
echo "-----------------------------------------------------------------------------------";
echo "";
echo "";



mkdir "${working_path}${working_dir}" 2> /dev/null;
mkdir "${working_path}${working_dir}/${tmp_dir}" 2> /dev/null;

ps -eo $format_ps > $ps_file;

Display (){
    if [ -n "$4" ]
    then
        # OUTPUT
        echo "Process #$nr";
        echo "  USER: $1";
        echo "  PID: $2";
        echo "  PPID: $3";
        echo "  CMD: $4";
        echo "  PCMD: $5";
        echo "";

        #LOG
        echo "$2,$1,$4,$3,$5" >> $log_file;
    fi
}


for i in $(seq $1);
do
    inotifywait -t1 -q $directories |
    ps -eo $format_ps | grep -vw "ps" | grep -vw "inotifywait"> $tmp_file; 
    diff $tmp_file $ps_file | grep "< " | sed 's/< //g' > $new_ps;
    while read line;
    do
        usr=$(echo $line | awk '{print $1}');
        pid=$(echo $line | awk '{print $2}');
        ppid=$(echo $line | awk '{print $3}');
        cmd=$(echo $line | awk '{for(i = 4; i <= NF; i++) {printf("%s ", $i)}}' | grep -e "$2" | sed 's/ $//');
        pcmd=$(cat $tmp_file | awk -v var="$ppid" '$2 == var {for(i = 4;i <= NF;i++) {printf("%s ", $i)}}' | sed 's/ $//');
        if [[ $pcmd != "[kthreadd]" ]];then
            Display $usr $pid $ppid "$cmd" "$pcmd";
        fi
        nr=$((nr+1));
    done < $new_ps;
    cat $tmp_file > $ps_file;
done
