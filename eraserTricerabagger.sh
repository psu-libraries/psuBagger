#!/bin/bash
# Updated 2016-12-14 by Nathan Tallman. This script should be scheduled to run every hour at 15 minutes past the hour.
# 2017-01-10 -- Is not erasing local copy right now, need to adjust code for this -- need to determine location 

# Variables
LOCAL=/mnt/libbag/tools/tricerabagger
CON=/mnt/libbag/
LOG=$LOCAL/logs/tricerabagger.txt
SENT=$LOCAL/logs/sentBags.txt
DEL=$LOCAL/logs/delBags.txt

echo -e "\n---------------------------------------------\n" >> $LOG 2>&1
echo "$(date): Tricerabagger Eraser will check the status of new bags sent to APTrust. If the bag has been ingested at APTrust, local bag files will be removed. Output will be sent to $LOG." 2>&1 | tee -a $LOG


# Test to see if there are any unconfirmed bags, if none, exit script.
if [[ -s $SENT ]] ; then
  # Read $DEL, for each line check if the bag has arrived at APTrust. If it was, delete local files.
  while read i; do
    if [ $(curl -s -N "URL" -H "Content-Type: application/json" -H "Accept: application/json" -H "X-Fluctus-API-User: tallmann@ucmail.uc.edu" -H "X-Fluctus-API-Key: 06d864ef2a5d8d1f3ff16de9c845281b23da8859"  "https://repository.aptrust.org/member-api/v1/items?name_exact=$i.tar&status=success" | $LOCAL/tools/jq/jq-linux64 'any(.results[]|.name; contains("'$i.tar'"))') == "true" ]; then
      rm -rf $CON/$i/ $CON/$i.tar && echo "Bag $i has been ingested at APTrust. All local bag files have been removed." 2>&1 | tee -a $LOG
      echo "$i" >> $DEL
    fi
    # Remove each ingested bag from the #SENT
    while read i; do
      sed -i "/$i/d" $SENT
    done < $DEL
    # Remove $DEL
    rm -rf $DEL 2>&1 | tee -a $LOG
   done < $SENT
else
  echo "No new bags have been sent, everything sent has been ingested at APTrust already." 2>&1 | tee -a $LOG
  echo -e "\n$(date): Tricerabagger Eraser  has finished." 2>&1 | tee -a $LOG
  exit 1
fi

echo -e "\n$(date): Tricerabagger Eraser has finished." 2>&1 | tee -a $LOG
