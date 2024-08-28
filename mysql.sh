#!/bin/bash

LOGS_FOLDER="/var/log/expense-shell"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%m_%s)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT(){

    if [ $USERID -ne 0 ] #user is not equal to zero it is not root
    then
        echo "plese run this script with root user access" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE(){

    if [ $1 -ne 0 ]
    then
        echo "$2 is failed" | tee -a $LOG_FILE
        exit 1
        else
        echo "$2 is success" | tee -a $LOG_FILE
    fi
}

CHECK_ROOT

dnf install mysql-server -y
VALIDATE $? "installing mysql server"

systemctl enable mysqld
VALIDATE $? "validate mysql server"

systemctl restart mysqld
VALIDATE $? "starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "setting up root password"


