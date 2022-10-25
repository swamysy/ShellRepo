#!/bin/bash
set -e

# Verify the scripts been executed using root user or not.
USERID=$(id -u)

if [ $USERID -ne 0 ] ; then
    echo -e "\e[31m You must run this script as a root user or with sudo privilige \e[0m"
    exit 1
fi

echo "Installing nginx package"
yum install nginx -y &>> /tmp/frontend.log
if [ $? -le 0 ] ; then
    echo -e "\e[32m Success \e[0m"
else 
    echo -e "\e[31m Failure \e[0m"
fi

echo "Downloading the frontend component"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl start nginx
