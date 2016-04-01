#!/bin/bash

# Variables
COL=/home/tallmann/bagging/scripts/collections.txt
CON=/home/tallmann/bagging/content
DSP=/local/dspace/bin/dspace
DES=tallmann@10.40.2.178:/home/tallmann/bagging/content
LOG=/home/tallmann/bagging/logs/exportAIPs.txt

#Script begins
echo "AIP export will now begin. This may take a while. Output is sent to /home/tallmann/bagging/scripts/log.txt."
echo -e "-------------------------------------------------------"  >> $LOG 2>&1
echo -e "\n$(date): Script begins to run."  >> $LOG 2>&1

# Export AIPs for all collections in collecitons.txt
while read f; do
    echo -e "\n\n----"  >> $LOG 2>&1
    echo "$(date): $f"  >> $LOG 2>&1
    yes y | $DSP packager -d -a -t AIP -e nathan.tallman@uc.edu -i 2374.UC/$f $CON/$f/$f.zip >> $LOG 2>&1
done <$COL

# Make all AIPs 777 so they can be used by users other than dspace
echo "Changed permissions on all AIPs to be 777." >> $LOG 2>&1
chmod -R 777 $CON  >> $LOG 2>&1

# Copy AIPs to DigProj, the dspace user on libdspprod has a key stored on digproj
echo "Copied all AIPs to DigProj." >> $LOG 2>&1
rsync -aqe ssh $CON/* $DES >> $LOG 2>&1

# Delete AIPs
rm -rf $CON/*
echo "Removed all AIPs from storage." >> $LOG 2>&1

# Script ends
echo -e "$(date): Script complete.\n"  >> $LOG 2>&1
echo "AIP export has completed."
