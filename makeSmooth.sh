#!/bin/bash

#################################
#                               #
#  Start configuration options  #
#                               #
#################################

# Directory where the images are stored (Pre-processed)
IMG_DIR=""

# Temp directory to save processed images in
TEMP_DIR="/tmp/$(date +"%s")"

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
    echo "    makeSmooth.sh [-?yc -s]"
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "    -y : Upload to Youtube                    (Default: No )"
    echo "    -c : Cleanup after creation (Use with -y) (Default: No )"
    echo "    -s : Scale of video output                (Default: [1024:768] )"
    echo ""
    echo ""
    echo "EXAMPLE:"
    echo "    ./makeSmooth.sh -yc -s 1024:768"
    echo ""
    exit $E_OPTERROR 
}

function MAKEMOVIE ()
{
    # Travel down to the temp dir
    cd $TEMP_DIR
    
    # First image produces a segmentation fault 
    # TODO: Figure out why
    rm "000000001.jpg"
    
    # Encode the movie
    mencoder "mf://*.jpg" -mf fps=22:type=jpg \
                          -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:vbitrate=7000 \
                          -noskip \
                          -vf scale=$SCALE \
                          -oac copy \
                          -o $SAVE_AS
}

function UPLOAD ()
{
    # Call the youtube uploader with required params
    python "$YTU_DIR/youtube_upload.py" --email="$YT_EMAIL" --password="$YT_PASS" \
                                        --category="Tech" \
                                        --title="My Video" \
                                        --description="" \
                                        --keywords="" \
                                        $SAVE_AS
}

function MAKESMOOTH () 
{    
    # Make the temp dir if it doesn't exist
    mkdir -p $TEMP_DIR
    
    # Get the current directory
    DIR="$( cd "$( dirname "$0" )" && pwd )"
    
    # Set the default previous image
    previousImg="$DIR/black.jpg"
    
    # Load all jpg files in specified directory into an array
    fileArray=($(find $IMG_DIR -type f -name "*.jpg"))
    
    # Get the length of the array (Number of jpg files)
    tLen=${#fileArray[@]}
    
    # Set counter for image names
    imagename=0
    
    # Set counter for total images processed
    total=0
    
    # For every image
    for (( j=0; j<${tLen}; j++ ));
    do
        # f is the file name
        f="${fileArray[$j]}"
            
            # Increase total by 1            
            let "total += 1"
            
            # Do some steps
            for c in {0..100..10}
            do
                # Increase imagename by 1  
                let "imagename += 1"
                
                # Buffer name with some 0's
                printf -v b "%09d" $imagename
                
                # Use ImageMagick to blend the image
                # Start with the original then slowly layer the next image ontop
                composite -quiet -blend $c $f $previousImg -alpha Set "$TEMP_DIR/$b.jpg" 
            done
            
            # make previousImg the current one now that we are done with it
            export previousImg="$f"
            
            # Show some nice output for the user
            echo -n -e "Processed $total / $tLen\r"
            
            # Sleep 3 seconds to let the CPU/RAM calm down
            # This can get quite intensive 
            sleep 3s
    done

}

function CLEANUP () 
{
    # Remove movie as it is now on youtube
    rm $SAVE_AS
    rm -rf $TEMP_DIR

}

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



# Check to see if scale has been set
# If not, set it to 1024:768 as default 
if [ -z $SCALE ]
then
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
