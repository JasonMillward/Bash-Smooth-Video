# Smooth Video Creation

This small script creates a smooth video based on a directory of jpg files with additional fading. 


[Preview of output](http://www.youtube.com/watch?v=zKM15etZ-Hs).



## Requirements
* ImageMagick
* python 2.6 or 2.7
* python-youtube-upload
* python-gdata


## Usage

### Fill in all of the configuration options at the top of the file.

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

* Movie scale, I'll used 1024:768 as the default
```./makeSmooth.sh -c 1024:768
```

* If you want to upload it to youtube when done;
```./makeSmooth.sh -y y -c 1024:768
```

* If you do not want to upload it; 
```./makeSmooth.sh -y n -c 1024:768
```


