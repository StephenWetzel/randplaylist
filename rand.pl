#!/usr/bin/perl
#Randomize VLC Playlist by Stephen Wetzel July 7 2014

use strict;
use warnings;
use autodie;

use List::Util qw/shuffle/; #shuffle array
#$|++; #autoflush disk buffer

my $inputFile = "p.xspf"; #set this = "" and it will take the filename from the command line
if (!$inputFile) {$inputFile = $ARGV[0];} #grab filename from command line if passed

my $outputFile = $inputFile;

my @fileArray; #stores lines of input files
my $thisLine; #store individual lines of input file in for loops
my @locations; #store the locations of movies


open my $ifile, '<', $inputFile;
@fileArray = <$ifile>;
close $ifile;
print "\nParsing input file...";
foreach $thisLine (@fileArray)
{
	if ($thisLine =~ m/<location>(.+)<\/location>/)
	{#this line should contain a location
		
		if ($1 eq "vlc://nop")
		{ }
		else
		{
			push(@locations, $1);
			#print "\nLocation: $1";
		}
	}
}


print "\nShuffling playlist...";
@locations = shuffle @locations;

print "\nOutputing playlist...";

open my $ofile, '>', $outputFile;	
	
print $ofile <<ENDTEXT;
<?xml version="1.0" encoding="UTF-8"?>
<playlist xmlns="http://xspf.org/ns/0/" xmlns:vlc="http://www.videolan.org/vlc/playlist/ns/0/" version="1">
	<title>Playlist</title>
	<trackList>
ENDTEXT

foreach my $thisItem (@locations) { print $ofile "\n\t\t<track>\n\t\t\t<location>$thisItem</location>\n\t\t</track>"; }

print $ofile <<ENDTEXT;
	</trackList>
</playlist>
ENDTEXT

close $ofile;



print "\n\nDone!\n";
