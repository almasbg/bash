#!/bin/bash

# Script created account and generates password on local unix system.


# If the user run script as root
if [[ "${UID}" -ne 0 ]]
then
	echo "Run script as root user"  >&2
	exit 1
	
fi

# If username wasn't provided, then give them help
if [[ "${#}" -lt 1 ]]
then
	echo "username not provided." >&2
	echo " Usage ${0} USER_NAME [COMMENT] ..." >&2
	exit 1
fi

# Use first argument as username
USERNAME=${1}

# other than first arguments will be comment
while [[ "${#}" -gt 1 ]]
do
	comment="${comment} ${2}"
	shift
done

# generate password using current date and time in milliseconds

PASSWORD=$(date +%s%N | sha256sum | head -c48)

# create user, if error occured exit with error display
useradd -c '${comment}' -m ${USERNAME} &> /dev/null
if [[ ${?} -ne 0 ]]
then
	echo "account wasn't created"
	exit 1
fi

echo "user for $USERNAME is created"

# enter password for new user
echo "${PASSWORD}" | passwd --stdin ${USERNAME} &> /dev/null
if [[ ${?} -ne 0 ]]
then
	echo "password failed" >&2
	exit 1 
fi

# force password change at first login
passwd -e ${USERNAME} &> /dev/null

echo "username: $USERNAME"
echo "password: $PASSWORD"
echo "Comment: $comment"
echo "hostname:"| hostname
