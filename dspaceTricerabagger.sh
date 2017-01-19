#!/bin/bash

# Updated 2017-01-12 by Nathan Tallman

# This script will take a directory of collection-level Dspace AIPs and process them into APTrust bags.

# Export tools are located in libdspprod:/home/dspace/dspaceExport -- feed the script a list of collection IDs for exporting

# Variables
LOCAL=/mnt/libbag/tools
CON=/mnt/libbag/DRC
BAGPY=$LOCAL/tricerabagger/tools/bagit-python/bagit.py
LOG=$LOCAL/tricerabagger/logs/tricerabagger.txt
SCRIP=$LOCAL/tricerabagger/scripts
DATE=`date +%Y-%m-%d`

echo -e "\n---------------------------------------------\n" >> $LOG 2>&1
echo "$(date): Tricerabagger will now process DRC AIPs into bags and TAR them. This may take awhile, output is logged in $LOG." 2>&1 | tee -a $LOG

# Unzip the AIPs
cd $CON
for f in */ ; do
  cd $f
    for z in *.zip ; do
      id=${z%.zip}
      mkdir $id
      unzip $z -d $id/ >> $LOG 2>&1
      rm $z
      rename \@ _ */
    done
  cd ../
done

# Make bag
cd $CON
for f in */ ; do
  id=${f%?}
  desc="$(xsltproc $SCRIP/bagInfo.xsl $id/$id/mets.xml)"
  $BAGPY $f --source-organization="University of Cincinnati Libraries" --bag-count="1 of 1" --internal-sender-identifier="https://hdl.handle.net/2374.UC/$id" --internal-sender-description="$desc" >> $LOG 2>&1
done

# Add aptrust-info.txt
cd $CON
for f in */ ; do
  cd $f
  id=${f%?}
  xsltproc -o aptrust-info.txt $SCRIP/aptrustInfo.xsl data/$id/mets.xml >> $LOG 2>&1
  cd ../
done

# split bags

# tar bags
cd $CON
for f in */ ; do
  id=${f%?}
  bag="cin.dspace.$id.$DATE"
  echo "$bag" >> $LOCAL/tricerabagger/logs/sentBags.txt
  mkdir $bag
  mv $f/* $bag/
  rmdir $f
  tar -cvf $bag.tar $bag/ >> $LOG 2>&1
  rm -rf $bag
done

# push bags
while getopts "s" OPT; do
  case $OPT in
    s)
      /usr/local/bin/aws s3 cp $CON/*.tar s3://aptrust.receiving.uc.edu 2>&1 | tee -a $LOG && echo "$bag.tar has been sent to APTrust." 2>&1 | tee -a $LOG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 2>&1 | tee -a $LOG
      ;;
  esac
done

echo "$(date): Tricerabagger is done." 2>&1 | tee -a $LOG
