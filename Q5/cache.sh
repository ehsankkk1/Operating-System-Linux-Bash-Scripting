#!/bin/bash

#reads all arguments provided
args="$@"
#hash the arguments using MD5 is 128-bit cryptographic hash to verify the file
md5Hash=$(echo "$args" | md5sum)

#create a directory if there's no existing one
directory="${HOME}/temp/cache"
mkdir -p "${directory}"

#creating a file (in the directory) and naming it with the hashed args 
cash_file="$directory/$md5Hash"

#setting expiration_time so the cache file stays valid only for one hour 
expiration_time=3600
#check if the file exists , if so , check its expiration time to see if the file is still valid 
# if the file is valid then view the content of the file
#else run the arguments as a command in the current shell and then put the result in the cash_file
test -f "${cash_file}" && [ $(expr $(date +%s) - $(date -r "$cash_file" +%s)) -le $expiration_time ] && cat "${cash_file}"|| (eval "$args" > "${cash_file}" && echo $(eval "$args"))



