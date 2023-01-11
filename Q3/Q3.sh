#!/bin/bash

add_datetime_header(){  
    echo $(date) >> $outfile  # add the date and time 
    return  #in the beginning of the monitoring segment
}

find_hundred(){     #top returns the percentage of idle use
    number=$1       # of the processor core and to calculate the percentage 
    used=$(echo "scale=4; 100.0 - ${number}" | bc)  #of usage
    echo "$used"    #  we need to do the operation: (use = 100 - idle)
    return
}

add_cron_job(){ # this function adds a cronjob to the crontab file
var=$(crontab -l | grep "\* 0 \* \* \* Q3 12 5")
if [ -z "$var" ]
then 
echo '* 0 * * * Q3 12 5' >> '/var/spool/cron/crontabs/root'
return 0
else    #and if there already is a cronjob it doesn't add a new one
return 0
fi
}

get_all_cores_usage(){  # get the usage of every cpu core
    var=$(cat $temp_file | grep '%Cpu') # read the temp file that has the monitoring data and find the lines that describe cpu core usage 
    
    sum=0
    iterations=0
    while IFS= read -r line;    # IFS splits the line according to new lines so every iteration is a cpu core
    do

    arr=$(echo "$line" | grep -Eo '[0-9]{1,3}[.][0-9][[:space:]]')  #get all float values in line

    idle=$(echo $arr | awk '{print $4}')    # get fourth float value (this is the idle usage value)
    usage=$(find_hundred $idle) # do the operation (usage = 100 - idle)

    sum=$(echo "scale=2; $sum+$usage" | bc)
    iterations=$((iterations + 1))

    line2="$line Usage: $usage" # new line is usage value in addition to the original top data 
    echo "$line2" >> $outfile   # append the data for every 
    done <<< $var   # read from var which holds every line of info from the temp file (top) about cpu cores
    average=$(echo "scale=2; $sum/$iterations" | bc)
    echo "Average Cpu Usage: $average" >> $outfile
    return
}

get_ram_usage(){
cat $temp_file | grep 'MiB Mem' >> $outfile    # get info about ram from temp file (top data)
return
}

get_disk_usage(){
var=$(df -h /)  # execute df from the root of the system
var1=$(echo "$var" | awk '{print $2}' | sed 's/Size/Size:/')    #extract useful info from df command
var2=$(echo "$var" | awk '{print $3}' | sed 's/Used/Used:/')
var3=$(echo "$var" | awk '{print $4}' | sed 's/Avail/Available: /')
echo 'Disk Usage: '$var1', '$var2', '$var3 >> $outfile  #output extracted info to the outfile
return
}

main(){
outfile="/opt/monitoring.txt"
temp_file="/opt/temp_file"  # temp file will have the info of the top command that all functions will use
top -1bn1 > $temp_file  # execute top once -1 means split cpu into cores -b formats output for files not cli
                        # n1 number of seconds of execution
add_cron_job
add_datetime_header
get_all_cores_usage
get_ram_usage
get_disk_usage
echo "" >> $outfile # add new line to outfile

rm $temp_file   #delete temp file
echo "monitor data appended successfully."
}

if [ $# -eq 0 ]     # if arguments are supplied then loop according to arguments
then
    main
else
    for (( c=1; c<=$1; c++))
        do
        main
        sleep $2
        done
fi