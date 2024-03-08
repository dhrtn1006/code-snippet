#!/bin/bash
DATE=$(date "+%Y%m%d")
BACKUP_DIR="절대경로"
BACKUP_DIR_MONTH="${BACKUP_DIR}MONGO_BACK/MONTH/"
BACKUP_DIR_WEEK="${BACKUP_DIR}MONGO_BACK/WEEK/"
BACKUP_DIR_DAY="${BACKUP_DIR}MONGO_BACK/DAY/"
DATABASE=""
USER=""
PWD=""

# 20th of every month Automatically saved in $BACKUP_DIR_MONTH
if [ $(date "+%d") == "20" ]
then
    mongodump --out $BACKUP_DIR_MONTH$DATE --host 127.0.0.1 --port 27017 -u $USER -p $PWD --db $DATABASE
fi

# monday of every week Automatically saved in $BACKUP_DIR_WEEK
if [ $(date "+%A") == "수요일" ]
then
    mongodump --out $BACKUP_DIR_WEEK$DATE --host 127.0.0.1 --port 27017 -u $USER -p $PWD --db $DATABASE
    PREV_DATE=`date --date '35 days ago' +%Y%m%d`
    rm -rf $BACKUP_DIR_WEEK$PREV_DATE
fi

# Automatically saved in $BACKUP_DIR_DAY every day
mongodump --out $BACKUP_DIR_DAY$DATE --host 127.0.0.1 --port 27017 -u $USER -p $PWD --db $DATABASE
PREV_DATE=`date --date '7 days ago' +%Y%m%d`
rm -rf $BACKUP_DIR_DAY$PREV_DATE