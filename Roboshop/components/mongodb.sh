#!/bin/bash
set -e

COMPONENT=mongodb
source components/common.sh

echo -n "Configuring the repo"
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
stat $?

echo -n "Installing $COMPONENT"
yum install -y mongodb-org &>> $LOGFILE
stat $?