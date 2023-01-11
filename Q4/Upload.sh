Script to upload file from pc to the server
#!/bin/bash
HOST='localhost'
USER='foo'
PASSWD='12345678'
FILE='example.txt'
REMOTE='/foo'
ftp -inv $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
cd $REMOTE
put $FILE
quit
END_SCRIPT
exit 0
