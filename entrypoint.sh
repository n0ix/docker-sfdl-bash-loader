#!/bin/bash
if [ ! -z ${Passwords} ];
then
    IFS=','
    read -ra PW <<< "$Passwords"
    for i in "${PW[@]}"; do
        echo "$i" >> /app/sfdl_bash_loader/sys/passwords.txt
    done
fi

if [ ! -z ${PasswordFile} ];
then
    cat "$PasswordFile" >> /app/sfdl_bash_loader/sys/passwords.txt
fi

/app/sfdl_bash_loader/start.sh