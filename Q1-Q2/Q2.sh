menu_choice=""
record_file=$1
source ./function_q2.sh $record_file
source ./auto.sh
temp_file=$(mktemp)
touch $temp_file; 
chmod 644 $temp_file
trap 'rm -f $temp_file' EXIT



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

#//////////////////////////////////////////////////////////////


add_backup(){

printf 'Choose backup Options:-'
printf '\n'
printf '\ta) Backup with zip\n'
printf '\tb) Backup with gzip\n'
printf '\tc) Backup with tar\n'
printf 'Please enter the choice then press return\n'
read back_up_option

case "$back_up_option" in
a) zip_backup;;
b) gzip_backup;;
c) tar_backup;;
*) printf "Sorry, choice not recognized";;
esac

return
}

#//////////////////////////////////////////////////////////////


restore_backup(){

printf 'Choose restore Options:-'
printf '\n'
printf '\ta) restore with zip\n'
printf '\tb) restore with gzip\n'
printf '\tc) restore with tar\n'
printf 'Please enter the choice then press return\n'
read restore_up_option

case "$restore_up_option" in
a) zip_restore;;
b) gzip_restore;;
c) tar_restore;;
*) printf "Sorry, choice not recognized";;
esac

}

#//////////////////////////////////////////////////////////////


auto_backup(){

printf 'Choose backup Options:-'
printf '\n'
printf '\ta) Daily BackUp\n'
printf '\tb) Weekly BackUp\n'
printf '\tc) Monthly BackUp\n'
printf 'Please enter the choice then press return\n'
read back_up_time

case "$back_up_time" in
a) daily_backup;;
b) weekly_backup;;
c) monthly_backup;;
*) printf "Sorry, choice not recognized";;
esac
}

#//////////////////////////////////////////////////////////////


set_menu_choice(){
clear
echo "DataBase now :" $record_file/$record_file.txt
printf 'Options:-'
printf '\n'
printf '\ta) Backup the database\n'
printf '\tb) Restore the database\n'
printf '\tc) Enable automatice backup\n'
printf '\tf) Quit\n'
printf 'Please enter the choice then press return\n'
read menu_choice
return
}

rm -f $temp_file
if [!-f $record_file/$record_file.txt];then
touch $record_file/$record_file.txt
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
a) add_backup;;
b) restore_backup;;
c) auto_backup;;
f) quit=y;;
*) printf "Sorry, choice not recognized";;
esac
done

rm -f $temp_file
echo "Finished"
exit 0

