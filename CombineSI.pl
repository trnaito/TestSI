#!/usr/bin/perl


## Usage: perl <program><space><scorefile><space><eventfile>
##
## perl CombineSI.pl GOOGL.SI.2015.Score.txt TRSI.TR.News.CMPNY_ALL.EN.2015.40020068.Flat-Event.txt
##

use strict;
use warnings;

my $scoreFile = $ARGV[0];
my $eventFile = $ARGV[1];

if($scoreFile eq '' || $eventFile eq '') {
    print "You need 2 arguments.\n";
    exit(-1);
}

open(SCORE, "< $scoreFile") or die $!;
open(EVENT, "< $eventFile") or die $!;
open(OUT, "> $scoreFile-EVENT.txt") or die $!;

my $sFileRowCount=0;
my $eFileRowCount=0;
my $oFileRowCount=0;
my @vLine=();

while(<SCORE>) {
    chomp;
    $sFileRowCount++;

    my @cLine = split('\t', $_);
    my $id = $cLine[0];

    ## Printing the header first.
    ##---------------------------
    if($sFileRowCount == 1) {
        print OUT join(',', @cLine);
        while(<EVENT>) {
            chomp;
            @vLine = split('\t', $_);
            print OUT join(',', @vLine),"\n";
            last;
        }
    }

    if($id =~ /^tr:+/) {

        while(<EVENT>) {
            chomp;

            @vLine = split('\t', $_);
            my $vId = $vLine[0];

            if($id eq $vId) {
                print "Printing line. \$id is $id. \$vId is $vId\n";
                print OUT join(',', @cLine);
                print OUT join(',', @vLine),"\n";
                last;
            }
        }
    }
}
close(EVENT);
close(SCORE);
close(OUT);

exit(0);

