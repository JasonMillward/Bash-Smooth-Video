#!/bin/bash

# Directory where the images are stored (Pre-processed)
IMG_DIR=""

# Temp directory to save processed images in
TEMP_DIR="/tmp/$(date +"%s")"

# Path and filename of the video
SAVE_AS="/tmp/movie.avi"

# Youtube automated uploader path (Optional)
YTU_DIR=""

# If using the automated uploader, email and password
# of the YouTube account
YT_EMAIL=""
YT_PASS=""

# YouTube movie parameters 
YT_CATEGORY="Tech"
YT_TITLE="My Movie"
YT_DESCRIPTION=""
YT_KEYWORDS=""

# Store the starting time
D1=`date +%s`

# Text color variables
txtred='\e[0;31m'       # red
txtgrn='\e[0;32m'       # green
txtwht='\e[1;37m'       # white
txtylw='\e[0;33m'       # yellow
txtrst='\e[0m'          # Text reset

