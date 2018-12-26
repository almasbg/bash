#!/bin/bash

if [[ ! -f ${1} ]]
then
	echo "Not found file"
	exit 1
fi

LIMIT=10

grep 'Failed' syslog-sample | awk -F 'from' '{print $2}' | awk -F 'port' '{print $1}'| sort -n | uniq -c | sort -rn | while read COUNT IP
do
  if [[ ${COUNT} -gt ${LIMIT} ]]
  then 
	LOCATION=$(geoiplookup ${IP} | awk -F ":" '{print $2}')
  	echo "Count: ${COUNT}, IP: ${IP}, LOCATION: ${LOCATION}"
  fi
done
