#!/bin/bash
#set -e

# Updated 2016-12-09 by Nathan Tallman

# Variables
LOCAL=/mnt/libbag/tools
CON=/mnt/libbag/scholar
BAGPY=$LOCAL/tricerabagger/tools/bagit-python/bagit.py
LOG=$LOCAL/tricerabagger/logs/tricerabagger.txt
DATE=`date +%Y-%m-%d`
DESC="Scholar@UC content as of $DATE"
BAGID=cin.scholar.$DATE

echo -e "\n---------------------------------------------\n" >> $LOG 2>&1
echo "$(date): Tricerabagger will now process the Scholar@UC data into a bag and TAR it. This may take awhile, output is logged in $LOG." 2>&1 | tee -a $LOG

# Create bag
$BAGPY $CON --source-organization="University of Cincinnati Libraries" --bag-count="1 of 1" --internal-sender-identifier="$BAGID" --internal-sender-description="$DESC" >> $LOG 2>&1

# Add aptrust-info.txt
cd $CON
echo "Title: Scholar@UC, $DATE" > aptrust-info.txt
echo "Access: Institution" >> aptrust-info.txt

# Split bags -- need to add code, will probably need to use bagit-java

# Tar bags
mkdir $BAGID
mv * $BAGID/ >> $LOG 2>&1
tar -cvf $BAGID.tar $BAGID/ >> $LOG 2>&1
echo "$BAGID.tar has been created." 2>&1 | tee -a $LOG

# Add BAGID to list of sent bags so ingest status can be monitored.
echo "$BAGID" >> $LOCAL/tricerabagger/logs/sentBags.txt


while getopts "s" OPT; do
  case $OPT in
    s)
      /usr/local/bin/aws s3 cp $CON/*.tar s3://aptrust.receiving.uc.edu 2>&1 | tee -a $LOG && echo "$BAGID.tar has been sent to APTrust." 2>&1 | tee -a $LOG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 2>&1 | tee -a $LOG
      ;;
  esac
done

echo "$(date): Tricerabagger is done." 2>&1 | tee -a $LOG
