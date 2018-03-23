#!/bin/bash
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt update
apt install -y mongodb-org
systemctl enable --now mongod
RES=$?
if [ $? -eq 0 ]; then
	echo "Mongo runs!"
else
	echo "Something went wrong with mongodb!"
fi
