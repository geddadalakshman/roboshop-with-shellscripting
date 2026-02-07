root_user_check() {
    if [ $(id -u) -ne 0 ]; then
        echo "You must be a root user to run this script."
        exit 1
    fi
}

status_check() {
    if [ $1 -eq 0 ]; then
        echo "SUCCESS"
    else
        echo "FAILURE"
        echo "Refer to the log file $LOG_FILE for more details."
        exit 1
    fi
}

