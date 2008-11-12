#!/usr/bin/perl -w

# This is very much alpha, hacky code.  Buyer beware!
# TODO: Allow user to selectively ignore time gaps between photos

if (!$ARGV[0]) {
    print "USAGE: findinteresting.pl path\n";
    exit;
}

my $path = $ARGV[0];

# first, find the last interesting image
# sort in reverse numerical order
$output = `ls -lr ${path}interesting/*.jpg`;
@output = split(/\n/, $output);
if ( !@output ) {
    $lastInterestingDateTime = "0";
} else {
    $lastInteresting = shift(@output);
    # using the same regex here as in the while loop below
    $lastInteresting =~ /(\d+ ... \d\d:\d\d).+[^0-9](([0-9]+)-([0-9]+)\.jpg)$/;
    $date = $3;
    $time = $4;
    $lastInterestingDateTime = "$date$time";
}
#print "$lastInterestingDateTime\n";

$output = `ls -lrt $path*.jpg`;
@output = split(/\n/, $output);

my $prevFile;
my $prevTime;
while (my $line = shift(@output)) {
    $line =~ /(\d+ ... \d\d:\d\d).+[^0-9](([0-9]+)-([0-9]+)\.jpg)$/;
    #my $datetime = $1;
    my $file = $2;
    my $date = $3;
    my $time = $4;
    
    if ( "$date$time" < $lastInterestingDateTime ) {
        #print "$date-$time\n";
        next;
    }
    
    if ($prevFile) {
        # need to pipe stderr to stdout
        $score = `compare -metric AE -fuzz 30% $path$file $path$prevFile output.jpg 2>&1`;
        #print "Score = $score";
        #$score =~ /(\d+)/;
        #print $1;
        $timeDiff = "$date$time" - $prevDateTime;
        #print "$file - $prevFile - $score\n";
        if ( $score > 35000 ) {
            if ( $timeDiff > 1000 || $timeDiff < 0 ) {
                print "Rejected: $file - $prevFile - $timeDiff\n";
            } else {
                #print "$file different than $prevFile - $score";
                `cp $path$file ${path}interesting/$file`;
            }
        }
    }

    $prevFile = $file;
    $prevDateTime = "$date$time";
}

`rm output.jpg`;

#print $output;