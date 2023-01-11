record_file=$1
cd $record_file;
zip_backup(){
printf '\Please Enter the File Name\n'
read fileName

#back up data base as zip 

zip $fileName $record_file.txt

return
}
gzip_backup(){
printf '\Please Enter the File Name\n'
read fileName

#back up data base as gz to the 
gzip -c $record_file.txt > $fileName.gz

return
}
tar_backup(){
printf '\Please Enter the File Name\n'
read fileName

#back up data base as tar 
# -c: Create an archive.
#-z: Compress the archive with gzip.
#-f: Allows you to specify the filename of the archive.

tar -czf $fileName.tar $record_file.txt
return
}



zip_restore(){

echo "Files found"
printf "$(find . -type f -name "*.zip")\n";
echo "Enter file name you want to restore";
read fileName;
unzip -o $fileName


}
gzip_restore(){

echo "Files found"
printf "$(find . -type f -name "*.gz")\n";
echo "Enter file name you want to restore";
read fileName;
# -k to keep original
gunzip -k $fileName.gz
# -f to force overWrite
mv -f $fileName $record_file.txt
get_return


}
tar_restore(){

echo "Files found"
printf "$(find . -type f -name "*.tar")\n";
echo "Enter file name you want to restore";
read fileName;
# -x: extract archive.
#-z: Compress the archive with gzip.
#-f: Allows you to specify the filename of the archive.
tar -xzf $fileName.tar


}



daily_backup(){

echo "enter number of backups"
read number

#write out current crontab
crontab -l > mycron.txt
LINE="0 0 * * * /bin/sh /home/ehsan/Desktop/OSH/auto_backup $record_file $number"

#check if line not already exist
#The -q option tells grep to be quiet
if ! grep -qF "$LINE" mycron.txt ; then echo "$LINE" >> mycron.txt ; fi

crontab mycron.txt
rm mycron.txt
return


}
weekly_backup(){

echo "enter number of backups"
read number

crontab -l > mycron.txt
LINE="0 0 * * 0 /bin/sh /home/ehsan/Desktop/OSH/auto_backup $record_file $number"

#check if line not already exist
#The -q option tells grep to be quiet
if ! grep -qF "$LINE" mycron.txt ; then echo "$LINE" >> mycron.txt ; fi

crontab mycron.txt
rm mycron.txt
return

}
monthly_backup(){

crontab -l > mycron.txt
LINE="0 0 1 * * /bin/sh /home/ehsan/Desktop/OSH/auto_backup $record_file $number"

#check if line not already exist
if ! grep -qF "$LINE" mycron.txt ; then echo "$LINE" >> mycron.txt ; fi

crontab mycron.txt
rm mycron.txt
return
}
