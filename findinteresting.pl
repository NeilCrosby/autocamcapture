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

$output = `ls -lrt $path*.jpg`;
@output = split(/\n/, $output);

my $prevFile;
my $prevTime;
my $count = 0;
my $compared = FALSE;
while (my $line = shift(@output)) {
    $line =~ /(\d+ ... \d\d:\d\d).+[^0-9](([0-9]+)-([0-9]+)\.jpg)$/;

    my $file = $2;
    my $date = $3;
    my $time = $4;
    
    if ( "$date$time" < $lastInterestingDateTime ) {
        next;
    }
    
    if ($prevFile) {
        # need to pipe stderr to stdout
        $score = `compare -metric AE -fuzz 30% $path$file $path$prevFile output.jpg 2>&1`;
        $compared = TRUE;

        $timeDiff = "$date$time" - $prevDateTime;

        if ( $score > 35000 ) {
            if ( $timeDiff > 1000 || $timeDiff < 0 ) {
                # print "Rejected: $file - $prevFile - $timeDiff\n";
            } else {
                `cp $path$file ${path}interesting/$file`;
                print "${path}interesting/$file\n";
                $count++;
            }
        }
    }

    $prevFile = $file;
    $prevDateTime = "$date$time";
}

if ( $compared ) {
    `rm output.jpg`;
}

print "$count interesting photos found\n";