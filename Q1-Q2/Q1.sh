
#get database from param
record_file=$1
#send database with param
source ./function_q1.sh $record_file
menu_choice=""




get_return(){
printf '\tPress return\n'
read x
return 0
}

get_confirm(){
printf '\tAre you sure?\n'
while true
do
  read x
  case "$x" in
      y|yes|Y|Yes|YES)
      return 0;;
      n|no|N|No|NO)
          printf '\ncancelled\n'
          return 1;;
      *) printf 'Please enter yes or no';;
  esac
done
}

set_menu_choice(){
clear
echo "DataBase now :" $record_file
printf 'Options:-'
printf '\n'
printf '\ta) Add new records\n'
printf '\tb) search for record\n'
printf '\tc) Update a record\n'
printf '\td) delete a record\n'
printf '\te) View Records\n'
printf '\tf) Quit\n'
printf 'Please enter the choice then press return\n'
read menu_choice
return
}

#//////////////////////////////////////////////////////////////


add_record(){

printf 'Enter record key:-'
read tmp
liKeyNum=$tmp

# check if the input isn't alphanumeric or length zero
if [[ "$liKeyNum" =~ [^a-zA-Z0-9] || -z "$liKeyNum" ]]; then
   echo "The input contains special characters."     
   echo "Input only alphanumeric characters." 
   get_return
   return
fi

printf 'Enter record value:-'
read tmp
liRecNum=$tmp

# check if the input isn't alphanumeric or length zero
if [[ "$liRecNum" =~ [^a-zA-Z0-9] || -z "$liRecNum" ]]; then
   echo "The input contains special characters."     
   echo "Input only alphanumeric characters." 
   get_return
   return
fi

base64Value=$(echo "$liRecNum" | base64)

printf 'About to add new entry\n'
printf "$liKeyNum : $liRecNum\n"

if get_confirm; then
   insert_record_function $liKeyNum" : "$base64Value 
fi
get_return
return

}

#//////////////////////////////////////////////////////////////


find_record(){

echo "Enter record key to find:";
read search;
search_for_record_function $search;
get_return
return
}

delete_record() {

linesfound=cat $record_file|wc -l
   case `echo $linesfound` in
   0)    echo "Sorry, nothing found\n"
         get_return	
         return 0
         ;;
   *)    echo "Found the following\n"
         view_records_function ;;
        esac
 printf "Type the record key which you want to delete\n"
 read searchstr


  if [ "$searchstr" = "" ]; then
      return 0
   fi
   
   delete_record_function $searchstr
  
  get_return
return
}

#//////////////////////////////////////////////////////////////


view_records(){
printf "List of records are\n"
view_records_function
get_return
return
}


#//////////////////////////////////////////////////////////////


update_record(){

printf "list of records are\n"
view_records_function
printf "Type the key of record you want to update\n"
read searchstr
  if [ "$searchstr" = "" ]; then
     return 0
  fi
delete_record_function $searchstr

printf 'Enter new record value:-'
read tmp
liRecNum=$tmp


base64Value=$(echo "$liRecNum" | base64)

printf 'About to add new entry\n'
printf "$searchstr : $liRecNum\n"

if get_confirm; then
   insert_record_function $searchstr" : "$base64Value 
fi
get_return
}

#//////////////////////////////////////////////////////////////

rm -f $temp_file
if [!-f $record_file/record_file.txt];then
touch $record_file/record_file.txt
fi

clear
printf '\n\n\n'
printf 'version 1 DB Management'
sleep 1

quit="n"
while [ "$quit" != "y" ];
do

set_menu_choice
case "$menu_choice" in
a) add_record;;
b) find_record;;
c) update_record;;
d) delete_record;;
e) view_records;;
f) quit=y;;
*) printf "Sorry, choice not recognized";;
esac
done

rm -f $temp_file
echo "Finished"

exit 0

