#!/bin/bash
DATE=$(date "+%Y%m%d")
BACKUP_DIR="절대경로"
BACKUP_DIR_MONTH="${BACKUP_DIR}SOURCE_BACK/MONTH/"
BACKUP_DIR_WEEK="${BACKUP_DIR}SOURCE_BACK/WEEK/"
BACKUP_DIR_DAY="${BACKUP_DIR}SOURCE_BACK/DAY/"
SOURCE_DIR="${BACKUP_DIR}/../*"
EXCLUDE="--exclude .git --exclude .gitignore --exclude AutoBack"

# 20th of every month Automatically saved in $BACKUP_DIR_MONTH
if [ $(date "+%d") == "20" ]
then
    tar -zcvf $BACKUP_DIR_MONTH"BACK_"$DATE.tar.gz $SOURCE_DIR $EXCLUDE
fi

# monday of every week Automatically saved in $BACKUP_DIR_WEEK
if [ $(date "+%A") == "수요일" ]
then
    tar -zcvf $BACKUP_DIR_WEEK"BACK_"$DATE.tar.gz $SOURCE_DIR $EXCLUDE
    PREV_DATE=`date --date '35 days ago' +%Y%m%d`
    rm -rf $BACKUP_DIR_WEEK"BACK_"$PREV_DATE.tar.gz
fi

# Automatically saved in $BACKUP_DIR_DAY every day
tar -zcvf $BACKUP_DIR_DAY"BACK_"$DATE.tar.gz $SOURCE_DIR $EXCLUDE
PREV_DATE=`date --date '7 days ago' +%Y%m%d`
rm -rf $BACKUP_DIR_DAY"BACK_"$PREV_DATE.tar.gz