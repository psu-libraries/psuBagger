#!/bin/bash

# Variables
BAGPY=/home/tallmann/bagging/tools/bagit-python/bagit.py
BAGJA=/home/tallmann/bagging/tools/baggit-4.12.0/bin/bagit
SCRIP=/home/tallmann/bagging/scripts/
CON=/home/tallmann/bagging/content/
LOG=/home/tallmann/bagging/logs/tricerabagger.txt

echo -e "\n---------------------------------------------\n" >> $LOG 2>&1
echo "$(date): Tricerabagger will now process the AIPs into bags and TAR them. This may take awhile, output is logged in $LOG." 2>&1 | tee -a $LOG

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
  bag="cin.dspace.$id"
  mkdir $bag
  mv $f/* $bag/
  rmdir $f
  tar -cvf $bag.tar $bag/ >> $LOG 2>&1
  rm -rf $bag
done

# push bags
if [ "$1" = "-push" ]; then
  for i in *.tar; do
    aws s3 cp $i s3://aptrust.receiving.uc.edu 2>&1 | tee -a $LOG
  done
fi

# delete bags

echo "$(date): Tricerabagger is done." 2>&1 | tee -a $LOG
