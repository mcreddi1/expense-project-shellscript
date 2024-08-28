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

echo "script started runnig at : $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing mysql server"

systemctl enable mysqld  &>>$LOG_FILE
VALIDATE $? "validate mysql server"

systemctl restart mysqld &>>$LOG_FILE
VALIDATE $? "starting mysql server"

mysql -h mysql.devops81s.shop -u root -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then 
     echo "root pass is not set, setting up now" &>>$LOG_FILE
     mysql_secure_installation --set-root-pass ExpenseApp@1 
     VALIDATE $? "setting the root password"
else

    echo "root password is already set, skipping now"
fi

#mysql -h mysql.daws81s.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
#if [ $? -ne 0 ]
#then
#    echo "MySQL root password is not setup, setting now" &>>$LOG_FILE
#    mysql_secure_installation --set-root-pass ExpenseApp@1
#    VALIDATE $? "Setting UP root password"
#else
#    echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a $LOG_FILE
#fi
