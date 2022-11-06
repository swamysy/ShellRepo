
# Verify the scripts been executed using root user or not.
USERID=$(id -u)
LOGFILE=/tmp/$COMPONENT.log

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

NODEJS(){
    echo -n "Configuring Node.js"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
    stat $?

    echo -n "Installing Nodejs"
    sudo yum install nodejs -y &>> $LOGFILE
    stat $?

    # CALLING CREATE_USER FUNCTION
    CREATE_USER

    # DOWNLOADING THE CODE
    DOWNLOAD_AND_EXTRACT

    # NPM INSTALL
    NPM_INSTALL

    # CONFIGURING SERVICE
    CONFIGURE_SERVICE
}

CREATE_USER(){
id $APPUSER &>> $LOGFILE
    if [ $? -ne 0 ]; then
        echo -n "Creating App User"
        useradd $APPUSER &>> $LOGFILE
        stat $?
    fi
}

DOWNLOAD_AND_EXTRACT() {
    echo -n "Downloading the $COMPONENT"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $?

    echo -n "Performing CleanUp"
    rm -rf /home/$APPUSER/$COMPONENT
    cd /home/$APPUSER
    unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE && v $COMPONENT-main $COMPONENT&>> $LOGFILE 
    stat $?

    echo -n "Changing permissions to $APPUSER"
    chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT && chmod -R 775 /home/roboshop/$COMPONENT
    stat $?

}

NPM_INSTALL() {
    echo -n "Installing $COMPONENT Dependencies:"
    cd $COMPONENT
    npm install &>> $LOGFILE
    stat $?
}

CONFIGURE_SERVICE() {
    echo -n "Configuring $COMPONENT service"
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/$COMPONENT/systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $?

    echo -n "Starting $COMPONENT service"

    systemctl daemon-reload &>> $LOGFILE
    systemctl start $COMPONENT &>> $LOGFILE
    stat $?
}