#!/bin/bash
#
#
#
#
#
#
#
#
#
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

function MAKEMOVIE ()
{
	mencoder "mf://*.jpg"   -mf fps=33:type=jpg \
	                        -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:vbitrate=7000 \
	                        -noskip \
	                        -vf scale=1024:768 \
	                        -oac copy  \
	                        -o $SAVE_AS
}

function UPLOAD ()
{
	python YTU_DIR --email="$YT_EMAIL" --password="$YT_PASS" \
                   --category="Tech" \
                   --title="" \
                   --description="" \
                   --keywords="" \
                   $SAVE_AS
}

function MAKESMOOTH () 
{
	# TODO: Fix path
	i=0
	now="/black.jpg"
	for f in *.jpg
	do
	        for c in {0..100..10}
	        do
	                let "i += 1"
	                printf -v b "%09d" $i
	                composite -blend $c $f $now -alpha Set  "/home/shodan/test/$b.jpg"
	        done
	        export now="$f"
	        echo "Processed $i"
	        sleep 3s
	done
}


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



