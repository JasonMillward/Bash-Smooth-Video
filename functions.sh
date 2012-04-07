#!/bin/bash

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

function SHOWTIME ()
{
    # Store the finishing time
    D2=`date +%s`

    # Do some subtraction
    ((diff_sec=D2-D1))

    # Use maths to show how long it took the script to complete
    echo ""
    echo -e "${txtgrn}Time to complete${txtrst}"
    echo - | awk '{printf "%d Hours %d Minutes %d Seconds","'"$diff_sec"'"/(60*60),"'"$diff_sec"'"%(60*60)/60,"'"$diff_sec"'"%60}'
    echo ""
}


function MAKEMOVIE ()
{
    echo -e "${txtwht}[$(date +"%r")] Starting movie making process...${txtrst}"
    # Travel down to the temp dir
    cd $TEMP_DIR

    # First image produces a segmentation fault
    # TODO: Figure out why
    rm "000000001.jpg"

    # Encode the movie
    mencoder "mf://*.jpg" -mf fps=30:type=jpg \
                          -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:vbitrate=7000 \
                          -noskip \
                          -vf scale=$SCALE \
                          -oac copy \
                          -o $SAVE_AS

    echo -e "${txtwht}Completed movie making process${txtrst}"
    echo ""
}

function UPLOAD ()
{
    echo -e "${txtwht}[$(date +"%r")] Starting upload process...${txtrst}"

    # Call the youtube uploader with required params
    python "$YTU_DIR/youtube_upload.py" --email="$YT_EMAIL" --password="$YT_PASS" \
                                        --category="$YT_CATEGORY" \
                                        --title="$YT_TITLE" \
                                        --description="$YT_DESCRIPTION" \
                                        --keywords="$YT_KEYWORDS" \
                                        $SAVE_AS

    echo -e "${txtwht}Completed upload process${txtrst}"
    echo ""
}

function MAKESMOOTH ()
{
    echo -e "${txtwht}[$(date +"%r")] Starting smoothing process...${txtrst}"

    # Make the temp dir if it doesn't exist
    mkdir -p $TEMP_DIR

    # Set the default previous image
    previousImg="$(dirname $0)/black.jpg"

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
    echo -e "${txtwht}Completed smoothing process${txtrst}"
    echo ""
}

function CLEANUP ()
{
    echo -e "${txtwht}[$(date +"%r")] Starting cleanup process${txtrst}"

    # Remove movie as it is now on youtube
    rm $SAVE_AS
    rm -rf $TEMP_DIR
    echo -e "${txtwht}Completed cleanup process${txtrst}"
    echo ""
}

