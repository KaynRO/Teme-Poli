#!/bin/bash

#Construim un vector cu numele tuturor fisierelor din directorul curent, presupunem ca nu avem subdirectoare. Important e sa excludem
#fisierele folosite de script folosing optiunea -v din grep
files=()

for i in `ls ./ | grep -v script.sh | grep -v log.txt`
do
	if test -f "$i"
	then
		files+=("$i")
	fi
done

#Vom declara doi vectori goi initial in care vom stoca ultimul access si modified time pentru fiecare fisier din calea curenta
access_time=()
moddified_time=()

echo "File name	|	Last modified time	|	User" > log.txt
echo "----------------------------------------	|	----------------------------------------	|	----------------------------------------" >> log.txt

#Pentru fiecare fisier din directorul curent salvam intr-un vector ultimul timp de access si de modificare al acestui fisier
for i in ${!files[@]}
do
    access_time+=("`stat ${files[$i]} | grep "Access: " | tail -n 1 | awk -F ": " '{print $2}' | cut -d ' ' -f1,2`")
    modified_time+=("`stat ${files[$i]} | grep "Modify: " | awk -F ": " '{print $2}' | cut -d ' ' -f1,2`")
done

#Scriptul va loga accessul la fisiere atat timp cat nu se schimba ziua curenta
current_day=`date +%j`

echo "-------------------------------------------------"
while [ `date +%j` -eq $current_day ]
do
    #Iteram prin lista de fisiere din director
    for i in ${!files[@]}
    do
        #Verificam last access time-ul current si il comparam cu cel salvat la inceputul rularii scriptului
        now_access="`stat ${files[$i]} | grep "Access: " | tail -n 1 | awk -F ": " '{print $2}' | cut -d ' ' -f1,2`"
        now_modified="`stat ${files[$i]} | grep "Modify: " | awk -F ": " '{print $2}' | cut -d ' ' -f1,2`"
        user=`ls -la ${files[$i]} | awk {'print $3}'`

        if [ "$now_access" != "${access_time[$i]}" ]
        then
            #Daca access time-urile difera atunci afisam datele aferente
            echo "[+] New access logged:"
            echo "File name:	`pwd`/${files[$i]}"
            echo "Access time:	$now_access"
            echo "User:		$user"
            echo "-------------------------------------------------"

            #Actualizam access time-ul fisierului in cauza
            access_time[$i]=$now_access
        fi

        if [ "$now_modified" != "${modified_time[$i]}" ]
        then
            #Daca modified_time-urile difera, atunci logam schimbarile intr-un fisier ca va urma a fi trimis la finalul zilei catre administrator
            echo "`pwd`/${files[$i]}	|	$now_modified	|	$user" >> log.txt
            echo "----------------------------------------	|	----------------------------------------	|	----------------------------------------" >> log.txt
            
            #De asemenea, actualizam modified time-ul fisierului
            modified_time[$i]=$now_modified
        fi
    done
done

#Trimitem mail catre administrator cu toate modificarile aduse fisierelor din directorul curent. Pentru partea de formatare sub forma tabelara
#am folosit comanda column ce identeaza automat in functie de un delimitator specificat, in cazul nostru fiind tab
mail -s "Fisiere modificate la data de `date | cut -d ' ' -f1,2,3,4" root@localhost <<< `columns -t -s $'\t' log.txt`