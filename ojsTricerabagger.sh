#!/bin/bash
#set -e

# Updated 2016-12-15 by Nathan Tallman

# Ideally will not rsync from server to server, but rsync on ojs server to libbag mount and then process form libarcmat1
# When rsyncing content from OJS server, don't use -a command as usually, this will copy broken sym links which will cause bagit-python to fail.
# Exclude cache and pdf plugin dir -- not necessary to include, not unique content and will be re-installed with OJS -- filenames cause problems.
# sudo rsync -h -vv -r -L --exclude 'cache' --exclude 'plugins/generic/pdfJsViewer/pdf.js/web/images' journals.uc.edu/* tallmann@digital.libraries.uc.edu:ojs/ -- ideally you rsync directly to libarcmat1, but permission are not complete. The broken sym links are in the PKP-OJS github repo too, never distributed.

# You will also need to grab a mysqldump of the database. Instructions below from Glen. -- can automate this when able.
#1) Log into the OJS production server
#2) mysqldump -h ucdbeil6.private -u wbu_journals -p journals > ~/ojs_production_dump.mysql
#3) You’ll then be prompted for a password that can be found on line 109 of /srv/www/journals.uc.edu/config.inc.php
#4) The file will be saved to ojs_production_dump.mysql in your home directory.

# Variables
LOCAL=/mnt/libbag/tools
CON=/mnt/libbag/ojs
BAGPY=$LOCAL/tricerabagger/tools/bagit-python/bagit.py
LOG=$LOCAL/tricerabagger/logs/tricerabagger.txt
DATE=`date +%Y-%m-%d`
NAME="Journals@UC"
DESC="$NAME content as of $DATE"
BAGID=cin.journals.$DATE

echo -e "\n---------------------------------------------\n" >> $LOG 2>&1
echo "$(date): Tricerabagger will now process the $NAME data into a bag and TAR it. This may take awhile, output is logged in $LOG." 2>&1 | tee -a $LOG

# Create bag
$BAGPY $CON --source-organization="University of Cincinnati Libraries" --bag-count="1 of 1" --internal-sender-identifier="$BAGID" --internal-sender-description="$DESC" >> $LOG 2>&1

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
