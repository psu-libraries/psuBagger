#!/bin/bash
set -e

# Updated 2017-10-13 by Nathan Tallman

# Variables
LOCAL=/bagging
CON=/mnt/preservationii/bagging_tests/pstsc/pstsc_02470
BAGPY=$LOCAL/psuBagger/tools/bagit-python/bagit.py
LOG=$LOCAL/psuBagger/logs/psuBagger.txt
DATE=`date +%Y-%m-%d`
NAME="The Pennsylvania State University Collection on Joseph Priestley"
DESC="$NAME content as of $DATE"
BAGID=psu.edu.pstsc.02470.$DATE

echo -e "\n--------------------------------------------\n" >> $LOG 2>&1
echo "$(date): psuBagger will now process the $NAME data into a bag and TAR it. This may take awhile, output is logged in $LOG." 2>&1 | tee -a $LOG

# Remove Mac and Windows system files
find $CON -iname '.DS_Store' -type f -delete
find $CON -iname '._.DS_Store' -type f -delete
find $CON -iname 'Thumbs.db' -type f -delete

# Create bag
$BAGPY --md5 $CON --source-organization="Penn State University Libraries" --bag-count="1 of 1" --internal-sender-identifier="$BAGID" --internal-sender-description="$DESC" >> $LOG 2>&1

# Add aptrust-info.txt
cd $CON
echo "Title: $NAME, $DATE" > aptrust-info.txt
echo "Access: Institution" >> aptrust-info.txt

# Split bags -- need to add code, will probably need to use bagit-java

# Tar bags
mkdir $BAGID >> $LOG 2>&1
mv * $BAGID/ >> $LOG 2>&1
tar -cvf $BAGID.tar $BAGID/ >> $LOG 2>&1
echo "$BAGID.tar has been created." 2>&1 | tee -a $LOG

# Add BAGID to list of sent bags so ingest status can be monitored.
echo "$BAGID" >> $LOCAL/psuBaggeragger/logs/sentBags.txt

while getopts "s" OPT; do
  case $OPT in
    s)
      /usr/bin/aws s3 cp $CON/*.tar s3://aptrust.receiving.psu.edu 2>&1 | tee -a $LOG && echo "$BAGID.tar has been sent to APTrust." 2>&1 | tee -a $LOG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 2>&1 | tee -a $LOG
      ;;
  esac
done

echo "$(date): psuBagger is done." 2>&1 | tee -a $LOG
