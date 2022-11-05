#!/bin/bash
set -e

COMPONENT=catalogue
APPUSER=roboshop
source components/common.sh

echo -n "Configuring Node.js"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
stat $?

echo -n "Installing Node.js"
yum install nodejs -y &>> $LOGFILE
stat $?

echo -n "Creating App User"
useradd $APPUSER
stat $?

echo -n "Downloading the component"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"  &>> $LOGFILE
stat $?

echo -n "Downloading the $COMPONENT code to $APPUSER home directory:"
cd /home/roboshop
unzip /tmp/catalogue.zip &>> $LOGFILE
mv $COMPONENT-main $COMPONENT
stat $?

echo -n "Installing nodejs dependencies:"
cd /home/roboshop/catalogue
npm install  &>> $LOGFILE
stat $?


