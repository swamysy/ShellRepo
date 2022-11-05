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

echo -n "Changing permissions to $APPUSER"
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT
stat $?

echo -n "Configuring $COMPONENT service"
sed -e 's/MONGO_DNSNAME/mongodb.robot.internal/' /home/roboshop/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "Starting $COMPONENT service"

systemctl daemon-reload &>> $LOGFILE
systemctl start $COMPONENT &>> $LOGFILE
stat $?
# systemctl enable catalogue
# systemctl status catalogue -l

echo -n "_______________$COMPONENT Installation is Successful______________"