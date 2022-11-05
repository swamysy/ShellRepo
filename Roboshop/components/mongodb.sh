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

echo -n "Updating the mongodb config"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "Starting MongoDb Service"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE

echo -n "Downloading the $COMPONENT Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Injecting the $COMPONENT Schema"
cd /tmp
unzip mongodb.zip
cd mongodb-main
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
stat $?

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js