#!/usr/bin/perl

# This is very much alpha, hacky code.  Buyer beware!

if (!$ARGV[0]) {
    print "USAGE: findinteresting.pl path\n";
    exit;
}

my $path = $ARGV[0];

$output = `ls -lrt $path*.jpg`;
@output = split(/\n/, $output);

my $prevFile;
my $prevTime;
while (my $line = shift(@output)) {
    $line =~ /(\d+ ... \d\d:\d\d).+[^0-9]([0-9]+-([0-9]+)\.jpg)$/;
    my $datetime = $1;
    my $file = $2;
    my $time = $3;
    
    if ($prevFile) {
        # need to pipe stderr to stdout
        $score = `compare -metric AE -fuzz 30% $path$file $path$prevFile output.jpg 2>&1`;
        #print "Score = $score";
        #$score =~ /(\d+)/;
        #print $1;
        $timeDiff = $time - $prevTime;
        if ( $score > 60000 ) {
            if ( $timeDiff > 1000 || $timeDiff < 0 ) {
                print "Rejected: $file - $prevFile - $timeDiff\n";
            } else {
                print "$file different than $prevFile - $score";
                `cp $path$file ${path}interesting/$file`;
            }
        }
    }

    $prevFile = $file;
    $prevTime = $time;
}

#print $output;