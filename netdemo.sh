#!/bin/bash

# This script ping a list of server and reports their status

SERVER_FILE='/home/vagrant/servers'

if [[ ! -e "${SERVER_FILE}" ]]
then
	echo "Cannot open ${SERVER_FILE}." >&2
	exit 1
fi



for SERVER in $(cat ${SERVER_FILE})
do
	echo "Pinging ${SERVER}"
	ping -c 1 ${SERVER} &> /dev/null
	if [[ "$?" -ne 0 ]]
	then
		echo "${SERVER} is down."
	else
		echo "${SERVER} is up."
	fi
done
