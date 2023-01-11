cd $1

random_number=$(echo $RANDOM | md5sum | head -c 5)
dir_num="$(ls | wc -l)"
if [ $((dir_num)) -le $2 ]; then
   zip "auto $random_number" $1.txt
else
#remove the oldest zip file 
rm "$(ls -t *.zip| tail -1 )"
zip "auto $random_number" $1.txt

fi
