#!/bin/bash
set -e

# Verify the scripts been executed using root user or not.
USERID=$(id -u)
COMPONENT=frontend

if [ $USERID -ne 0 ] ; then
    echo -e "\e[31m You must run this script as a root user or with sudo privilige \e[0m"
    exit 1
fi

stat() {
    if [ $1 -le 0 ] ; then
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
    fi
}

echo -n "Installing nginx package"
yum install nginx -y &>> /tmp/$COMPONENT.log
stat $?

echo -n "Downloading the frontend component"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "Performing Cleanup"
rm -rf /usr/share/nginx/html/* &>> /tmp/$COMPONENT.log
stat $?

cd /usr/share/nginx/html

echo -n "Unzipping the component"
unzip /tmp/frontend.zip &>> /tmp/$COMPONENT.log
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
systemctl enable nginx &>> /tmp/$COMPONENT.log
systemctl start nginx &>> /tmp/$COMPONENT.log
stat $?