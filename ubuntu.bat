@echo off
docker network create ubuntu > NUL 2>&1
docker volume create docker > NUL
docker volume create mongodb > NUL
docker volume create nginx > NUL
docker volume create ubuntu > NUL
docker run -it --rm --privileged --net=ubuntu -v mongodb:/var/lib/mongodb -v docker:/var/lib/docker -v nginx:/etc/nginx -v ubuntu:/home/ubuntu -v %HOMEDRIVE%%HOMEPATH%:/home/ubuntu/host:cached %UBUNTU_PARAMS% %* josei/ubuntu
