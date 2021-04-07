#!/bin/sh

echo '[+]Building docker image: docker build. -t task1'
docker build . -t task1

echo '[+]Running container, exposed port 8080: docker run -it -p 8080:80 task1'
docker run -it -p 8080:80 task1

echo '[+]Finding task1 docker ID'
ID=`sudo docker container ls -a | tr -s ' ' '\t' | cut -f1,2 | grep task1 | cut -f1`
echo '[+]Container ID: $ID'

echo -n '[+]Stopping container: docker stop '
echo $ID
docker stop $ID

echo -n '[+]Removing container: docker rm '
echo $ID
docker rm ID