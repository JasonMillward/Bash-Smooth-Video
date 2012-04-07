# Smooth Video Creation

This small script creates a smooth video based on a directory of jpg files with additional fading. 


[Preview of output](http://www.youtube.com/watch?v=zKM15etZ-Hs).



## Requirements
* ImageMagick
* python 2.6 or 2.7
* python-youtube-upload
* python-gdata


## Usage

### Fill in all of the configuration options inside the config.sh file.

* Directory that contains the images you wish to convert into a movie
```IMG_DIR=""```

* Directory that will hold the converted images (So nothing is overwritten)
```TEMP_DIR="/tmp/$(date +"%s")"```

* File and path to where you would like to save the movie when compiled
```SAVE_AS="/tmp/movie.avi"```

* Path to python-youtube-upload
```YTU_DIR=""```

* YouTube Email (Only for uploading)
```YT_EMAIL=""```

* YouTube Password (Only for uploading)
```YT_PASS=""```


### Add in the required arguments;

* Movie scale, 1024:768 is the default but if you want something else
```./makeSmooth.sh -s 600:400```

* If you want to upload it to YouTube when done;
```./makeSmooth.sh -y -s 600:400```

* After uploading it to YouTube, you want to clean up the left over files
```./makeSmooth.sh -yc -s 600:400
```

* To erase everything without uploading to YouTube
```./makeSmooth.sh -c -s 600:400```


