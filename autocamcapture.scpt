------------------------------------------------------------------------------
-- A script designed to be run every n minutes to capture your surroundings
-- as you go about your day to day business.
--
-- @author Neil Crosby <neil@thetenwordreview.com>
-- @license http://creativecommons.org/licenses/by-sa/3.0/
------------------------------------------------------------------------------

--- Basic script paths.  You might want to change these.
set commandPath to "/Applications/autocamcapture/"
set commandName to "camcapture"
set outputImagePath to "~/Pictures/autocamcapture/"

-- First, delay for five seconds.  The script seems to get upset if you try
-- to use the webcam whilst the system is still waking up.  It's cranky like
-- that.
delay 5

-- Now we work out what to call the image we're about to create.
-- HINT: it's YYYYMMDD-HHMMSS.jpg
set outputImageName to do shell script "date +%Y%m%d%H%M%S"

-- Finally, we run camcapture as a shell script.
-- It's run as a shell script because otherwise OSX gets upset and refuses to
-- let you access the webcam.
do shell script commandPath & commandName & " " & outputImagePath & outputImageName