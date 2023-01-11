#!/bin/bash
HOST='localhost'
USER='foo'
PASSWD='12345678'
SOURCE='/foo'
DEST='/home/nicolasalahmar/Desktop/Project/Q4'
FILE='File1.txt'
ftp -inv $HOST <<EOF
quote USER $USER
quote PASS $PASSWD
cd $SOURCE
lcd $DEST
get $FILE
bye
EOF
