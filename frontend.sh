#!/bin/bash
source common.sh

root_user_check

set -e

echo "Installing nginx..."
yum install nginx -y >>$LOG_FILE 2>&1
status_check $?

echo "Enabling and starting nginx service..."
systemctl enable nginx >>$LOG_FILE 2>&1
systemctl start nginx >>$LOG_FILE 2>&1
status_check $?

echo "Cleaning existing nginx html directory..."
rm -rf /usr/share/nginx/html/* >>$LOG_FILE 2>&1
status_check $? 

echo "Downloading frontend artifacts..."
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip >>$LOG_FILE 2>&1
status_check $?

echo "Extracting frontend files..."
cd /usr/share/nginx/html >>$LOG_FILE 2>&1
unzip /tmp/frontend.zip >>$LOG_FILE 2>&1
status_check $?

echo "Updating nginx configuration..."
cp ${code_dir}/config/nginx.conf /etc/nginx/roboshop.conf >>$LOG_FILE 2>&1
status_check $?

echo "Restarting nginx..."
systemctl restart nginx >>$LOG_FILE 2>&1
status_check $?

echo "Frontend setup completed successfully!"
