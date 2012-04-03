#!/bin/bash

#################################
#                               #
#  Start configuration options  #
#                               #
#################################

# Directory where the images are stored (Pre-processed)
IMG_DIR="/home/user/images"

# Temp directory to save processed images in
TEMP_DIR="/tmp/$(date +"%s")/"

# Path and filename of the video
SAVE_AS="/tmp/movie.avi"

# Youtube automated uploader path (Optional)
YTU_DIR=""

# If using the automated uploader, email and password 
# of the youtube account
YT_EMAIL=""
YT_PASS=""


#################################
#                               #
#   End configuration options   #
#                               #
#################################

function USAGE ()
{
    echo ""
    echo "USAGE: "
    echo "    makeSmooth.sh [-?sb]"
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "EXAMPLE:"
    echo "    makeSmooth.sh ..."
    echo ""
    exit $E_OPTERROR 
}

#PROCESS ARGS
while getopts ":s:b:?" Option
do
    case $Option in
        s    ) SA=$OPTARG;;
        b    ) BA=$OPTARG;;
        ?    ) USAGE
               exit 0;;
        *    ) echo ""
               echo "Unimplemented option chosen."
               USAGE
    esac
done



