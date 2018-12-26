#!/bin/bash

# Merge two strings if finds match words in the string
# and prints it to output.file in same directory
# Use ./merg_file.sh file1 column1 file2 column2

file1=$1
col1=$2
file2=$3
col2=$4
while read mline; 
do
  SecColumn=$(echo $mline | awk -v var="$col1" '{ print $var }')
  while read eline;
  do 
  	FirstColumn=$(echo $eline | awk -v var2="$col2" '{ print $var2 }')

	if [[ ${SecColumn} = ${FirstColumn} ]]
	then
		echo "$mline    $eline"
		echo "$mline	$eline" >> output.file
		break
	fi
  done < ${file2}
done < ${file1}
