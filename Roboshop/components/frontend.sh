#!/bin/bash
set -e

COMPONENT=frontend
source components/common.sh

echo -n "Installing nginx package"
yum install nginx -y &>> $LOGFILE
stat $?

echo -n "Downloading the frontend component"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "Performing Cleanup"
rm -rf /usr/share/nginx/html/* &>> $LOGFILE
stat $?

cd /usr/share/nginx/html

echo -n "Unzipping the component"
unzip /tmp/frontend.zip &>> $LOGFILE
stat $?
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md &>> $LOGFILE

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