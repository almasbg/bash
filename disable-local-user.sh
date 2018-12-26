#!/bin/bash


ARCHIVE_DIR="/archive"


if [[ $UID -ne 0 ]]
then
	echo "Please login as root or use sudo" >&2
	exit 1
fi

usage() {
 echo "Usage: ${0} [-drv] [-a] USERNAME" >&2
 echo "disable user account"
 echo ' -d  deletes account instead of disabling'
 echo ' -r  remove the home directory associated with the account'
 echo ' -a  archive home directory and store /archive'
 echo ' -v  verbose'
 exit 1
}


log () {
 local MESSAGE="${@}"
 if [[ "${VERBOSE}" = 'true' ]]
 then
 	echo "${MESSAGE}"
 fi
}


while getopts drva OPTION
do 
 case ${OPTION} in
  d)
	DELETE='true'
	;;
  r)
	REMOVE='-r'
	;;
  v)
	VERBOSE='true'
	log "Verbose is on"
	;;
  a)
	ARCHIVE='true'
	;; 
  ?)
	usage
	exit 1
	;;
 esac	
done
echo ${OPTIND}
# take out all options and leave only usernames
shift "$(( OPTIND - 1 ))"

# check if there any user was entered
if [[ "${#}" -lt 1 ]]
then
	usage
	exit 1
fi

# Run loop for all usernames and check if they have id less then 1000.
for USERNAME in "${@}"
do
 USERID=$(id -u ${USERNAME})
 if [[ ${USERID} -lt 1001 ]] 
 then
	echo "${USERNAME} has id ${USERID}, not able to delete system user"
	exit 1
 fi
 

# Archive option selected: check for directory and home directory then tar zip home directory.
 if [[ ${ARCHIVE} = 'true' ]]
 then
  if [[ ! -d "${ARCHIVE_DIR}" ]]
  then 
	mkdir -p ${ARCHIVE_DIR}
	log "created ${ARCHIVE_DIR}"
	if  [[ "${?}" -ne 0 ]]
	then 
	  echo "not able to create directory ${ARCHIVE_DIR}"
	  exit 1
	fi
  fi	
 
  HOME_DIR="/home/${USERNAME}"
  ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.gz"
  if [[ -d ${HOME_DIR} ]]
  then
   tar -zcvf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
   log "creating tar zip file"
   if [[ ${?} -ne 0 ]]
   then
 	echo "couldn't archive directory"
 	exit 1		
   fi
  fi
 fi
# Delete option selected or disable will work.
 if [[ ${DELETE} = 'true' ]]
 then
	log "deleting user"
	userdel ${REMOVE} ${USERNAME}
 else
	chage -E 0 ${USERNAME}
 fi
 
done



