#!/bin/bash
source common.sh
root_user_check
set -e

echo "Setting up MongoDB repository..."
cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo >>$LOG_FILE 2>&1
status_check $?

echo "Installing MongoDB..."
yum install mongodb-org -y >>$LOG_FILE 2>&1
status_check $?

echo "Enabling and starting MongoDB service..."
systemctl enable mongod >>$LOG_FILE 2>&1
systemctl start mongod >>$LOG_FILE 2>&1
status_check $?

echo "Updating MongoDB listen address..."
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf >>$LOG_FILE 2>&1
status_check $?

echo "Restarting MongoDB service..."
systemctl restart mongod >>$LOG_FILE 2>&1
status_check $?

