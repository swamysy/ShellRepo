#!/bin/bash
set -e

COMPONENT=mongodb

echo -n "Configuring the repo"
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
stat $?

echo -n "Installing $COMPONENT"
yum install -y mongodb-org &>> $LOGFILE
systemctl enable mongod
systemctl start mongod

echo -n "Performing Cleanup"
rm -rf /usr/share/nginx/html/* &>> $LOGFILE
stat $?

cd /usr/share/nginx/html

echo -n "Unzipping the component"
unzip /tmp/frontend.zip &>> $LOGFILE
stat $?

mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md

echo -n "Configuring the reverse proxy settings"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -n "Starting the nginx service"
systemctl enable nginx &>> $LOGFILE
systemctl start nginx &>> $LOGFILE
stat $?