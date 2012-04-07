#!/bin/bash

# Lets include the reqired files
source $(dirname $0)/config.sh
source $(dirname $0)/functions.sh


# Get options and flags
while getopts "ycs:?" Option
do
    case $Option in
        y    ) YOUTUBE=true;;
        c    ) CLEAN=true;;
        s    ) SCALE=$OPTARG;;
        ?    ) USAGE
               exit 0;;
        *    ) echo ""
               echo "Unimplemented option chosen."
               USAGE
    esac
done

# Show that the script has started 
echo -e "${txtwht}Script initialised${txtrst}"

# Check to see if scale has been set
# If not, set it to 1024:768 as default 
if [ -z $SCALE ]
then
    echo -e "${txtylw}No scale set, using default: 1024:768${txtrst}"
    SCALE="1024:768"
fi

# Start the ImageMagick
MAKESMOOTH

# Encode the movie 
MAKEMOVIE

# Upload to YouTube if specified
if [ $YOUTUBE ]
then
    UPLOAD   
fi

# Cleanup leftover files
# If you use this without uploading to YouTube you will use everything
if [ $CLEAN  ]
then
    CLEANUP
fi

# Show time for completion
SHOWTIME
