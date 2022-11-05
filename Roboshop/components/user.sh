#!/bin/bash
set -e

COMPONENT=user
APPUSER=roboshop
source components/common.sh

echo -n "Configuring Node.js"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
stat $?

# echo -n "Installing Nodejs"
# sudo yum install nodejs -y &>> $LOGFILE
# stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ]; then
    echo -n "Creating App User"
    useradd $APPUSER
    stat $?
fi

echo -n "Downloading the component"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Moving $COMPONENT code to $APPUSER home directory:"
cd /home/$APPUSER
unzip /tmp/$COMPONENT.zip &>> $LOGFILE
mv $COMPONENT-main $COMPONENT 
stat $?

echo -n "Installing nodejs dependencies:"
cd $COMPONENT
npm install  &>> $LOGFILE
stat $?

echo -n "Changing permissions to $APPUSER"
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT && chmod -R 775 /home/roboshop/$COMPONENT
stat $?

echo -n "Configuring $COMPONENT service"
sed -i -e 's/MONGO_ENDPOINT/mongodb.robot.internal/' -e 's/REDIS_ENDPOINT/redis.robot.internal/' /home/roboshop/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "Starting $COMPONENT service"

systemctl daemon-reload &>> $LOGFILE
systemctl start $COMPONENT &>> $LOGFILE
stat $?
# systemctl enable catalogue
# systemctl status catalogue -l

echo -n "_______________$COMPONENT Installation is Successful______________"