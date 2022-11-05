
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