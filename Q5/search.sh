#!/bin/bash

function details(){

	name=$1
	details=$(stat -c "file_type: %F, permissions: %A, user: %U, group: %G" $1)
	printf "\nfile name: $name
	file details: $details\n"  
}

#Export the function to all child process

export -f details

#loop for all args (files or directories) provided to the bash script
for var in "$@"
	do
	#the {} represents the current file (argument) proccessed , and it's sent to the function "details" as a parameter.
    		(find . / -name "*$var*"  -exec bash -c 'details "${1}"' -- {} \; )  &
	done
