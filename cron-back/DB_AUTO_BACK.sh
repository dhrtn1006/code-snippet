#!/bin/bash
DATE=$(date "+%Y%m%d")
BACKUP_DIR="절대경로"
BACKUP_DIR_MONTH="${BACKUP_DIR}DB_BACK/MONTH/"
BACKUP_DIR_WEEK="${BACKUP_DIR}DB_BACK/WEEK/"
BACKUP_DIR_DAY="${BACKUP_DIR}DB_BACK/DAY/"
USER=""
PWD=""

# 20th of every month Automatically saved in $BACKUP_DIR_MONTH
if [ $(date "+%d") == "20" ]
then
    mysqldump -u $USER -p $PWD --all-databases > $BACKUP_DIR_MONTH"BACK_"$DATE.sql
fi

# monday of every week Automatically saved in $BACKUP_DIR_WEEK
if [ $(date "+%A") == "수요일" ]
then
    mysqldump -u $USER -p $PWD --all-databases > $BACKUP_DIR_WEEK"BACK_"$DATE.sql
    PREV_DATE=`date --date '35 days ago' +%Y%m%d`
    rm -rf $BACKUP_DIR_WEEK"BACK_"$PREV_DATE.sql
fi

# Automatically saved in $BACKUP_DIR_DAY every day
mysqldump -u $USER -p $PWD --all-databases > $BACKUP_DIR_DAY"BACK_"$DATE.sql
PREV_DATE=`date --date '7 days ago' +%Y%m%d`
rm -rf $BACKUP_DIR_DAY"BACK_"$PREV_DATE.sql