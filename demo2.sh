#!/bin/bash

docker images
docker ps
docker run -d -p0.0.0.0:80:80 ubuntu:latest
docker ps -a
docker run -it --name my-ubuntu ubuntu /bin/bash  # type exit
docker start my-ubuntu
docker ps

docker rename my-ubuntu purple
docker stop purple
docker rm purple

