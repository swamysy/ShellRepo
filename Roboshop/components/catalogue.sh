#!/bin/bash
set -e

COMPONENT=catalogue
APPUSER=roboshop
source components/common.sh

echo -n "Configuring Node.js"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
stat $?

# echo -n "Installing Nodejs"
# yum install nodejs -y &>> $LOGFILE
# stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ]; then
    echo -n "Creating App User"
    useradd $APPUSER
    stat $?
fi

echo -n "Downloading the component"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"  &>> $LOGFILE
stat $?

echo -n "Downloading the $COMPONENT code to $APPUSER home directory:"
cd /home/roboshop
unzip /tmp/catalogue.zip &>> $LOGFILE
mv $COMPONENT-main $COMPONENT &>> $LOGFILE
stat $?

echo -n "Installing nodejs dependencies:"
cd $COMPONENT
npm install  &>> $LOGFILE
stat $?