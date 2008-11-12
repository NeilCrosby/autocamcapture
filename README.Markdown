# Find Interesting

This little project is designed to sit alongside the [autocamcapture][1] code I wrote that automatically takes a photograph using your Mac's inbuilt iSight every minute.  This script trawls the photos that were automatically taken and finds ones which are sufficiently different from those around them to possibly be interesting.  These "interesting" photos are then placed in a folder called "interesting" inside the one that you were trawling.

The script tries to be a little sensible and carry on where it left off each time that it's run, rather than reprocessing images that it's already seen.


[1]: http://thecodetrain.co.uk/2008/11/how-to-automatically-take-photos-using-your-macs-webcam/