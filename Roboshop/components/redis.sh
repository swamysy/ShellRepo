#!/bin/bash

set -e

COMPONENT=catalogue
APPUSER=roboshop
source components/common.sh

echo -n "Configuring Redis"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOGFILE
stat $?

echo -n "Installing Redis"
yum install redis-6.2.7 -y &>> $LOGFILE
stat $?

echo -n "Whitelisting redis to others:"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/redis.conf
stat $?

echo -n "Starting $COMPONENT service"
systemctl daemon-reload
systemctl start redis
stat $?
