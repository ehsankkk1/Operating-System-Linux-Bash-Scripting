record_file=$1/$1.txt
temp_file=$(mktemp)
touch $temp_file; 
chmod 644 $temp_file
trap 'rm -f $temp_file' EXIT

# Question one /////////////////////
insert_record_function(){
echo $* >>$record_file
return
}

search_for_record_function(){

cat $record_file | while read line 
do
  # get key before :
  key=$(cut -d ":" -f1 <<< "$line")
  
  # if key contains search 
  if [[ $key == *"$1"* ]]; then 
      # get value after :
      value=$(cut -d ":" -f2 <<< "$line")
      # remove white spaces 
       value="${value%"${value##*[![:space:]]}"}"
       base64Value=$(echo -n $value | base64 --decode)
       echo $key": "$base64Value
   fi

done
}


delete_record_function(){

   # Note : regex to delete line that start with word 
  sed -r "/^$searchstr\b/d" $record_file > $temp_file;
  mv $temp_file $record_file
  
}

view_records_function(){
cat $record_file | while read line 
do
   # get key before :
   key=$(cut -d ":" -f1 <<< "$line")
   # get value after :
   value=$(cut -d ":" -f2 <<< "$line")
   # remove white spaces 
   value="${value%"${value##*[![:space:]]}"}"
   base64Value=$(echo -n $value | base64 --decode)
   echo $key": "$base64Value
 
done
return
}






















