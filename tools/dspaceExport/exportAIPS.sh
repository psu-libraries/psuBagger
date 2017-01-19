#!/bin/bash

# script must be run as the dspace user


# Variables
LOCAL=/mnt/bagging
COL=$LOCAL/tricerabagger/tools/export/collections.txt
CON=$LOCAL/exports
DSP=/local/dspace/bin/dspace
LOG=$LOCAL/tricerabagger/logs/exportAIPs.txt

#Script begins
echo "AIP export will now begin. This may take a while. Output is sent to $LOG "
echo -e "-------------------------------------------------------"  >> $LOG 2>&1
echo -e "\n$(date): Script begins to run."  >> $LOG 2>&1

# Export AIPs for all collections in collecitons.txt
while read f; do
    echo -e "\n\n----"  >> $LOG 2>&1
    echo "$(date): $f"  >> $LOG 2>&1
    yes y | $DSP packager -d -a -t AIP -e nathan.tallman@uc.edu -i 2374.UC/$f $CON/$f/$f.zip >> $LOG 2>&1
done <$COL

# Script ends
echo -e "$(date): Script complete.\n"  >> $LOG 2>&1
echo "AIP export has completed."
