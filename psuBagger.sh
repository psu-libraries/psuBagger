#!/bin/bash
#set -e

# Updated 2017-12-19 by Nathan Tallman

# Need to make the script fail to run if these arguments aren't present.
while getopts i:n:p: option
do
 case "$option"
 in
 i) colid=$OPTARG;;
 n) name=$OPTARG;;
 p) path=$OPTARG;;
 esac
done

# Variables
local=/bagging/psuBagger
bagpy=$local/tools/bagit-python/bagit.py
log=$local/logs/psuBagger.txt
DATE=`date +%Y-%m-%d`
desc="$name content as of $DATE."
bagid="psu.edu.$colid.$DATE"

echo -e "\n--------------------------------------------\n" >> $log 2>&1
echo "$(date): psuBagger will now process the $name data into a bag and TAR it. This may take awhile, output is logged in $log." 2>&1 | tee -a $log

# Remove Mac and Windows system files
find $path -iname '.DS_Store' -type f -delete
find $path -iname '._.DS_Store' -type f -delete
find $path -iname 'Thumbs.db' -type f -delete
find $path -iname '.apdisk' -type f -delete
find $path -iname '._.apdisk' -type f -delete
find $path -iname '.Bridge*' -type f -delete
find $path -iname '.TemporaryItems' -type f -delete
find $path -iname '.Trashes' -delete
find $path -iname '._.Trashes' -delete

# Create bag
$bagpy --md5 $path --processes 6 --source-organization="Penn State University Libraries" --bag-count="1 of 1" --internal-sender-identifier="$bagid" --internal-sender-description="$desc" >> $log 2>&1

# Add aptrust-info.txt
cd $path
echo "Title: $name, $DATE" > aptrust-info.txt
echo "Access: Institution" >> aptrust-info.txt

# Tar bags
mkdir $bagid >> $log 2>&1
mv * $bagid/ >> $log 2>&1
tar -cvf $bagid.tar $bagid/ >> $log 2>&1
echo "$bagid.tar has been created." 2>&1 | tee -a $log

echo "$(date): psuBagger is done." 2>&1 | tee -a $log
