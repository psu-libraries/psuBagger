# PSU Bagger

## psuBagger.sh
 * This script may be used to convert any directory into an APTrust bag. It will bag in-place, not output a new directory. As of 2017-11-15, it must be run as the sudo user.
 * The following arguments must be used for the script to work.
    * `-i` for the identifier of the content being bagged
    * `-n` for the name of the content being bagged
    * `-p` for the absolute path to the content being bagged
 * Minimal output will be directed to the terminal, verbose logging is in `/bagging/psuBagger/logs/psuBagger.txt`
 * Example usage:
   * `sudo ./psuBagger.sh -i pstsc_01417 -n "Three Mile Island Records" -p /mnt/preservationii/bagging/pstsc_01417`

## psuBaggerUploader.sh
 * This script will do everything above, but also send the bag to APTrust.

## eraserBagger.sh
  * This script needs to be updated to use the APTrust member API. psuBagger adds the bag ID to a text file. eraserBagger checks those IDs against what has been ingested at APTrust. When a bag is fully ingested, eraserBagger will remove the bag from staging.

## Dependencies
  * [APTrust Partner Tools](https://wiki.aptrust.org/Partner_Tools#Config_Fi) require a configuration file for each user (`~/.aptrust_partner.conf`) to be established in advance.
  * bagit-python will need to be separately downloaded to `tools/bagit-python`.
