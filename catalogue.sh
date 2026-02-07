#!/bin/bash
source common.sh

root_user_check

set -e

echo "Installing NodeJS..."
yum install nodejs -y >>$LOG_FILE 2>&1
status_check $?

echo "Adding roboshop user..."
useradd roboshop >>$LOG_FILE 2>&1 || true
status_check $?

echo "Creating application directory..."
mkdir -p /app >>$LOG_FILE 2>&1
status_check $?

echo "Downloading application code..."
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
status_check $?

echo "Extracting application code..."
cd /app >>$LOG_FILE 2>&1
unzip /tmp/catalogue.zip >>$LOG_FILE
status_check $?

echo "Installing application dependencies..."
npm install >>$LOG_FILE 2>&1
status_check $?

echo "Setting up systemd service..."
cp ${code_dir}/config/catalogue.service /etc/systemd/system/catalogue.service >>$LOG_FILE 2>&1
status_check $?

echo "Reloading systemd daemon..."
systemctl daemon-reload >>$LOG_FILE 2>&1
status_check $?

echo "Enabling and starting catalogue service..."
systemctl enable catalogue >>$LOG_FILE 2>&1
systemctl start catalogue >>$LOG_FILE 2>&1
status_check $?

echo "Catalogue service setup completed successfully!"
