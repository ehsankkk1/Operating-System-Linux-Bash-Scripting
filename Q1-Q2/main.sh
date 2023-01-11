database="error"
launch_data_base(){

quit="n"
while [ "$quit" != "y" ];
do
clear
echo "DataBase now :" $database
printf 'Options:-'
printf '\n'
printf '\ta) Question 1\n'
printf '\tb) Question 2\n'
printf '\tf) Quit\n'
printf 'Please enter the choice then press return\n'
read menu_choice

case "$menu_choice" in
a) ./Q1.sh $database
;;
b) ./Q2.sh "$database"
;;
f) quit=y;;
*) printf "Sorry, choice not recognized";;

esac
done
 
}

if [ $# -gt 2 ]
then
echo "invalid input" 

else
case "$1" in 
 -c|--create)
   if [ -d "./$2" ]
   then
   echo "Database already created!"
   database=$2;
   
   
   else 
   echo "Creating Database $2"
   mkdir $2 && touch $2/$2.txt
   database=$2
   launch_data_base;
   fi ;;

 *)
  if [ -d "./$1" ]
  then
  echo "Launching dataBase!"
  database=$1
  launch_data_base;
  else 
  echo "Data Base not found!" 
  fi
  ;;
esac
fi
 


