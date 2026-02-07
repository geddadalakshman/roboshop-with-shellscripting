#!/bin/bash
code_dir=$(pwd)
source common.sh

root_user_check

set -e

LOG_FILE="/tmp/frontend-setup.log"

# Create log file if it doesn't exist
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Redirect stdout and stderr to log file + console
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Installing nginx..."
yum install nginx -y
status_check $?

echo "Enabling and starting nginx service..."
systemctl enable nginx
systemctl start nginx
status_check $?

echo "Cleaning existing nginx html directory..."
rm -rf /usr/share/nginx/html/*
status_check $?

echo "Downloading frontend artifacts..."
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
status_check $?

echo "Extracting frontend files..."
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
status_check $?

echo "Updating nginx configuration..."
cp ${code_dir}/config/nginx.conf /etc/nginx/roboshop.conf
status_check $?

echo "Restarting nginx..."
systemctl restart nginx
status_check $?

echo "Frontend setup completed successfully!"
