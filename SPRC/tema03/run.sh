#!/bin/bash

echo '[+] Checking if current user is root. If not, change it'
[ `whoami` = root ] || exec su -c $0 root

echo -e '\n[+] Docker init swarm'
docker swarm init

echo -e '\n[+] Building adapter image'
docker image build --tag mqttadapter mqttadapter/

echo -e '\n\n[+] Stoping possibly existing stack'
docker stack rm sprc3 2> /dev/null

echo -e '\n[+] Creating docker networks'
docker network create --driver=overlay broker_adapter 2> /dev/null
docker network create --driver=overlay grafana_influx 2> /dev/null
docker network create --driver=overlay adapter_influx 2> /dev/null
sleep 1

echo -e '\n[+] Creating the docker volumes in the desired path ($SPRC_DVP). Copying grafana configuration and adapter source code there'
echo '$SPRC_DVP='$SPRC_DVP
mkdir $SPRC_DVP/influxdb 2> /dev/null
sudo cp -r grafana $SPRC_DVP/ 2> /dev/null
sudo cp -r mqttadapter $SPRC_DVP/ 2> /dev/null

echo -e '\n[+] Deploying stack'
docker stack deploy -c stack.yml sprc3
sleep 3

echo -e '\n\n[+] Checking stack'
docker stack services sprc3
