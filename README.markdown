# Autocamcapture

The autocamcapture script is designed to be run from a cronjob every n minutes.  The point is to automatically take pictures of you throughout your day, because occasionally something interesting will happen.

I originally wrote about this in a [blog post][1].

# Finding the Interesting Photos

Finding the interesting photos can be a challenge though.  If you were to leave your laptop on for 8 hours a day with this script running every minute (as I do) you would end up with 480 photos being taken every single day.

My current work in progress solution is to periodically run the "findinteresting.pl" script, which scans through the autocamcapture photos that have been taken since the last time it was run, finding photos that are sufficiently different from the previous one.  These "interesting" photos are then placed in a folder called "interesting" inside the one you were trawling.

Currently the script ignores the previous photos if they were taken more than n minutes apart, as the thinking is that the location of your laptop will probably have changed during that time.

findinteresting.pl requires you to have installed the ImageMagick suite of tools.

# Oh noes for early adopters

If you were an early adopter of this script, you'll have images being created with dashes in their filenames.  Unfortunately, things have changed and that dash is no longer wanted.  Fortunately it's pretty darned easy to rename all those files.  Just cd into the directory your images are being created in, and then run the following command:

    for file in *.jpg ; do mv $file `echo $file | sed 's/-//g'`; done

You might want to do that in the `interesting` directory too.

[1]: http://thecodetrain.co.uk/2008/11/how-to-automatically-take-photos-using-your-macs-webcam/
