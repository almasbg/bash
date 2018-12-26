#!/bin/bash

# Usage for script
usage() {
 echo "Usage ${0} [-nsv] -f file COMMAND"
 echo "run command on multiple server in /home/vagrant/server"
 echo "-n dry run"
 echo "-s run with sudo priviligies"
 echo "-v enable verbose"
 echo "-f specify new file with host lists"
 exit 1
}

# Verbose message function
log() {
 local MESSAGE="${@}"
 if [[ "${VERBOSE}" = 'true' ]]
 then
	echo "${MESSAGE}"
 fi 
}

# ssh with 2 sec timeout
SSH_OPTION='-o ConnectTimeout=2'

# location of default file with server list
SERVER_LIST="/home/vagrant/servers"

# Make sure user run script not as root
if [[ "${UID}" -eq 0 ]]
then
	echo "Don't use root or sudo to run the scipt."
	exit 1
fi

# Parse the options.
while getopts f:nsv OPTION
do
 case ${OPTION} in
  n)
	DRY_RUN='true'
	;;
  s)
	SUDO='sudo'
	;;
  v)
	VERBOSE='true'
	log 'verbose is on.'
	;;
  f)
	SERVER_LIST="${OPTARG}"
  	;;
  ?)
	usage
	;;
 esac
done


# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

# If the user doesn't supplu at least one argument, let him know to do so
if [[ "${#}" -lt 1 ]]
then 
	echo "if -lt 1"
	usage
fi

# Get all arguments after removing options
COMMAND="${@}"

# Make sure the SERVER_LIST exits
if [[ ! -e ${SERVER_LIST} ]]
then
	echo "File ${SERVER_LIST} doesn't exist"
	exit 1
fi

# Loop through server list and run command on each host in file.
for SERVER in $(cat ${SERVER_LIST})
do

  SSH_COMMAND="ssh ${SSH_OPTION} ${SERVER} ${SUDO} ${COMMAND}"


  if [[ "${DRY_RUN}" = 'true' ]]
  then
  	echo "DRY RUN: ${SSH_COMMAND}"
  else
  	log "Executing command: ${COMMAND} on ${SERVER}"
	${SSH_COMMAND}
  	if [[ ${?} -ne 0 ]]
	then 
		echo "Execution failed on ${SERVER}." >&2
	fi
  fi


done
