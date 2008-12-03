#!/usr/bin/perl -w

# USAGE: findinteresting.pl imagedirectory
#
# @author Neil Crosby <neil@neilcrosby.com>
# @license http://creativecommons.org/licenses/by-sa/3.0/
#
# This is very much alpha, hacky code.  Buyer beware!
# TODO: Allow user to selectively ignore time gaps between photos

if (!$ARGV[0]) {
    print "USAGE: findinteresting.pl path\n";
    exit;
}

my $path = $ARGV[0];

# first, find the last interesting image
# sort in reverse numerical order
$output = `find ${path}interesting/ -type f -name '*.jpg'`;
@output = split(/\n/, $output);
if ( !@output ) {
    $lastInterestingDateTime = "0";
} else {
    $lastInteresting = pop(@output);
    # using the same regex here as in the while loop below
    $lastInteresting =~ /([0-9]+)\.jpg$/;
    $lastInterestingDateTime = $1;
}

$output = `find $path -type f -name '*.jpg'`;
@output = split(/\n/, $output);

my $prevFile;
my $prevTime;
my $count = 0;
my $compared = FALSE;
while (my $line = shift(@output)) {
    if ( $line =~ /interesting/ ) {
        next;
    }
    
    $line =~ /([0-9]+)\.jpg$/;

    my $datetime = $1;
    
    if ( $datetime < $lastInterestingDateTime ) {
        next;
    }
    
    if ($prevFile) {
        # need to pipe stderr to stdout
        $score = `compare -metric AE -fuzz 30% $path$datetime.jpg $path$prevFile output.jpg 2>&1`;
        $compared = TRUE;

        $timeDiff = $datetime - $prevDateTime;

        if ( $score > 35000 ) {
            if ( $timeDiff > 1000 || $timeDiff < 0 ) {
                #print "Rejected: $datetime.jpg - $prevFile - $timeDiff\n";
            } else {
                `cp $path$datetime.jpg ${path}interesting/$datetime.jpg`;
                print "${path}interesting/$datetime.jpg\n";
                $count++;
            }
        }
    }

    $prevFile = $datetime.'.jpg';
    $prevDateTime = $datetime;
}

if ( $compared ) {
    `rm output.jpg`;
}

print "$count interesting photos found\n";