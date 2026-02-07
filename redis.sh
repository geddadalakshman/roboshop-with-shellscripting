#!/bin/bash
source common.sh
root_user_check
set -e  

echo "Setting up Redis repository..."
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

echo "Enabling Redis module..."
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?


echo "Installing Redis..."
yum install redis -y >>$LOG_FILE 2>&1
status_check $?

echo "Updating Redis configuration..."
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf >>$LOG_FILE 2>&1
status_check $?

sed -i -e 's/protected-mode yes/protected-mode no/' /etc/redis/redis.conf >>$LOG_FILE 2>&1
status_check $?

echo "Enabling and starting Redis service..."
systemctl enable redis >>$LOG_FILE 2>&1
systemctl start redis >>$LOG_FILE 2>&1
status_check $?

