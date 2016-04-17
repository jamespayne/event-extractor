#!/usr/bin/env perl

# Scripting Langugae Programming Assignment 1
# Perl Email Event Extraction Script by James Payne(s3435992)
# RMIT University 2016

use strict;
use warnings;
use Data::Dumper;


# Start main command line checks and file validation.

# Check to see if the required input file has been supplied and there are no
# more than 1 arguments for input.

if (!$ARGV[0] || @ARGV > 1){
  print "\nYou didn't supply an input file or you have supplied too many\n";
  print "arguments. Please read the documentation!\n\n";
  exit;
}

# Check the file name argument has a .json extension.

if ($ARGV[0] =~ /\.json$/i){
  print "Valid .json file submitted. Thank you.\n";
} else {
  print "That doesn't appear to be a valid .json file.\n";
  exit;
}

# Create a new filehandler and open the file given as input.

open (my $inputFile, $ARGV[0]) || die "Error in opening the file";

# Set up the global variables and arrays.

my @input = ();
my $inputSize = 0;
my @datetimes = ();
my $datetimesSize = 0;

my $monthsMatch = "(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)";

my %months = qw(january 1 jan 1 february 2 feb 3 march 3 mar 3 april 4 apr 4 may 5 june 6 jun 6 july 7 jul 7 august 8 aug 8 september 9 sep 9 sept 9 october 10 oct 10 november 11 nov 11 december 12 dec 12);

# Extract the data from the input file and push it into an array of hashes for further analysis and processing.

while (<$inputFile>){

  #  Need to to check this regex for format. Tzd seems to be fixed but may not pick up.

  # Exract the timestamp.

  if($_ =~ /sent/){
    my ($year, $month, $day, $hours, $minutes, $seconds, $tzd) = $_ =~ /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}).(\d{2,4}Z)/;
    $input[$inputSize]{'email'}{'timestamp'} = $year.'-'.$month.'-'.$day.'T'.$hours.':'.$minutes.':'.$seconds.'.'.$tzd;
  }

  # Extract the time zone

  if($_ =~ /timeZone/){
    my ($timeZone) = $_ =~ /(\w*\/\w*)/;
    $input[$inputSize]{'email'}{'timezone'} = $timeZone;

  }

  # Extract the content

  if($_ =~ /content/){
    my ($content) = $_ =~ /"content":\h"(.*)"/g;

    # Start by extracting the datetimes.

    while($content =~ /(\d{1,2})\h(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)\h(\d{1,2}):?(\d?\d?)(?:pm|am)?\h-\h(\d{1,2}):?(\d?\d?)/gi){

      my $year = 1900 + (localtime)[5];
      my $day = $1;
      my $month = $months{lc$2};
      my $startHour = $3;
      my $startMinute  = $4;
      my $endHour = $5;
      my $endMinute = $6;

      # Clean up the dates and add leading and trailing zeros where needed.

      $day = "0".$day if length($day) < 2;
      $month = "0".$month if length($month) < 2;
      $startMinute = "00" if !$startMinute;
      $endMinute = "00" if !$endMinute;

      # Convert hours to 24h format.

      if($startHour > $endHour){
        $endHour += 12;
      } elsif($startHour < $endHour){
        $endHour += 12;
        $startHour += 12;
      }

      $datetimes[$datetimesSize]{'event'}{'timestamp'} = $input[$inputSize]{'email'}{'timestamp'};
      $datetimes[$datetimesSize]{'event'}{'timezone'} = $input[$inputSize]{'email'}{'timezone'};
      $datetimes[$datetimesSize]{'event'}{'start'} = $year."-".$month."-".$day."T".$startHour.":".$startMinute.":00.00Z";
      $datetimes[$datetimesSize]{'event'}{'end'} = $year."-".$month."-".$day."T".$endHour.":".$endMinute.":00.00Z";

      $datetimesSize++;

    }

    # Set the timezone as Melbourne if a timezone is not found.

    if(!defined $input[$inputSize]{'email'}{'timezone'}){
      $input[$inputSize]{'email'}{'timezone'} = "Australia/Melbourne";
    }

    $inputSize++;

  }
}

# Close the input file.

close($inputFile);

printToOutputFile();

open (my $outFile, ">output.json") || die "Error in opening the file";

sub printToOutputFile {

  my $datetimeSize = @datetimes-1;
  my $eventCount = 0;

  print $outFile "[\n";

  for(my $i = 0; $i <= $datetimeSize; $i++){

    print $outFile "\t{\n";
    print $outFile "\t\t".'"start" : {'."\n";
    print $outFile "\t\t\t".'"datetime": '.'"'.$datetimes[$i]{'event'}{'start'}.'"';
    print $outFile ",\n" if $eventCount <= $datetimeSize;
    print $outFile "\t\t\t".'"timezone": '.'"'.$datetimes[$i]{'event'}{'timezone'}.'"'."\n";
    print $outFile "\t\t}";
    print $outFile ",\n" if $eventCount <= $datetimeSize;
    print $outFile "\t\t".'"end" : {'."\n";
    print $outFile "\t\t\t".'"datetime": '.'"'.$datetimes[$i]{'event'}{'end'}.'"';
    print $outFile ",\n" if $eventCount <= $datetimeSize;
    print $outFile "\t\t\t".'"timezone": '.'"'.$datetimes[$i]{'event'}{'timezone'}.'"'."\n";
    print $outFile "\t\t}";
    print $outFile "\n" if $eventCount <= $datetimeSize;
    print $outFile "\t}";
    print $outFile "," if $eventCount <= $datetimeSize -1;
    print $outFile "\n";

    $eventCount++;

  }

  print $outFile "]\n";
  close($outFile);

}


# Debug Area

# print Dumper @input;
# print Dumper @datetimes;

# Start POD

=pod

=head1 NAME

eventExtractor

=head1 SYNOPSIS

eventextractor [inputfile]

=head1 DESCRIPTION

B<eventExtractor> is a utility to extract events from a given json formatted
file. The events are then output to an output file called 'output.json'. It is
designed to detect all day and multiple time based events.

=head1 OPTIONS

=over 4

=item inputfile

This is the file to file to be presented as input. E.g. eventExtractor.pl input.json

For more information on the JSON format, visit http://json.org

=back

=head3 I<--BUGS>

Please report bugs s3435992@student.rmit.edu.au.


=head3 I<--AUTHOR>

James Payne, School of Computer Science & Information Technology, RMIT


=head3 I<--LICENSE>

Copyright (c) 2016 by James Payne

=cut
