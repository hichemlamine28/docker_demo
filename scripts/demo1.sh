#!/bin/bash

docker images
docker pull mysql

docker run -d -p0.0.0.0:80:80 mysql:latest
docker ps # container is down

docker run -it --name sl mysql /bin/bash # type exit 
docker start sl
docker ps

docker images
docker image rm -f image mysql
docker images

docker image rm -f image <id>  # must be not in use
sudo docker kill sl

############################
# list all folder elements on a browser
docker run -tdi --name my-apache-app -p 8080:80 -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4


# nginx example:
docker run -tdi --name <conatiner-name> -p 8080:80 -v path-file:$PATH-CONTAINER <image>
docker run -tdi --name nginx-hichem -p  8080:80 -v "$PWD"/web:/usr/share/nginx/html/ nginx


# BUILD image from Dockerfile, push to dockerhub:
cd web
docker build -t hichem-nginx .
docker run -tdi --name nginx-hichem -p  8080:80 hichem-nginx