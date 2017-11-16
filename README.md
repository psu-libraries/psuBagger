# PSU Bagger

## directoryBagger.sh
 * This script may be used to convert any directory into an APTrust bag. It will bag in-place, not output a new directory. As of 2017-11-15, it must be run as the sudo user.
 * Variables in the script need to be changed each time it is used: 
    * $CON for the path to the content
    * $NAME for the bag name
    * $BAGID for the bag ID.
 * Minimal output will be directed to the terminal, verbose logging is in /bagging/psuBagger/logs/psuBagger.txt
 * Use the `-s` option to send the bag to APTrust.

## eraserBagger.sh
  * This script needs to be updated to use the APTrust member API. psuBagger adds the bag ID to a text file. eraserBagger checks those IDs against what has been ingested at APTrust. When a bag is fully ingested, eraserBagger will remove the bag from staging.


## Dependencies
  * AWS CLI must be configured for each user who sends content to APTrust or runs the psuBagger scripts, this includes `sudo`. 
    * /usr/local/bin/aws 
    * [http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
  * bagit-python will need to be separately downloaded to psuBagger/tools/bagit-python.
