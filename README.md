# Smooth Video Creation

This small script creates a smooth video based on a directory of jpg files with additional fading. 


[Preview of output](http://www.youtube.com/watch?v=zKM15etZ-Hs).



## Requirements
* ImageMagick
* python 2.6 or 2.7
* python-youtube-upload
* python-gdata


## Usage
Fill in all of the configuration options at the top of the file.

### Add in the required arguments;

* Movie scale, 1024:768 is the default
```./makeSmooth.sh -c 1024:768
```

* If you want to upload it to youtube when done;
```./makeSmooth.sh -y y -c 1024:768
```
* If you do not want to upload it; 
```./makeSmooth.sh -y n -c 1024:768
```


