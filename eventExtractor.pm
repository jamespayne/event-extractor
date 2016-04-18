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

# Set up the global variables, arrays and hashes for later use.

my @input = ();
my $inputSize = 0;
my @events = ();
my $eventsSize = 0;

my $monthsMatch = "(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)";

my %months = qw(january 1 jan 1 february 2 feb 2 march 3 mar 3 april 4 apr 4 may 5 june 6 jun 6 july 7 jul 7 august 8 aug 8 september 9 sep 9 sept 9 october 10 oct 10 november 11 nov 11 december 12 dec 12);

my %mdays = qw(1 31 2 28 3 31 4 30 5 31 6 30 7 31 8 31 9 30 10 31 11 30 12 31);

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

    # Extract the datetime events.

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

      $events[$eventsSize]{'event'}{'timestamp'} = $input[$inputSize]{'email'}{'timestamp'};
      $events[$eventsSize]{'event'}{'timezone'} = $input[$inputSize]{'email'}{'timezone'};
      $events[$eventsSize]{'event'}{'start'} = $year."-".$month."-".$day."T".$startHour.":".$startMinute.":00.00Z";
      $events[$eventsSize]{'event'}{'end'} = $year."-".$month."-".$day."T".$endHour.":".$endMinute.":00.00Z";
      $events[$eventsSize]{'event'}{'type'} = 'datetime';

      $eventsSize++;

    }

    # Set the timezone as Melbourne if a timezone is not found.

    if(!defined $input[$inputSize]{'email'}{'timezone'}){
      $input[$inputSize]{'email'}{'timezone'} = "Australia/Melbourne";
    }

    # Extract the forward date events.

    while($content =~ /(\d{1,2})(?:th)?\h(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec).,?\h(\d{4})/gi){

        my $startDay = $1;

        my $endDay = $startDay + 1;
        my $month = $months{lc$2};

        my $year = $3;

        # Compensate for days rolling over into next month. This needs some further refinement to compensate for leap years. Need some sort of algorithm to check whether feb is in a leap year. Also, it may be that an event starts on 31st December the end date would be 1 Jan the next year.

        if($endDay > $mdays{$month}){
          $month += 1;
          $endDay = 1;
        }

        # Add leading zeros if month is single digit. This could be done using some sort of date conversion or string formatting but working for now.

        $month = "0".$month if length($month) < 2;
        $startDay = "0".$startDay if length($startDay) < 2;
        $endDay = "0".$endDay if length($endDay) < 2;

        $events[$eventsSize]{'event'}{'timestamp'} = $input[$inputSize]{'email'}{'timestamp'};
        $events[$eventsSize]{'event'}{'timezone'} = $input[$inputSize]{'email'}{'timezone'};
        $events[$eventsSize]{'event'}{'start'} = $year."-".$month."-".$startDay;
        $events[$eventsSize]{'event'}{'end'} = $year."-".$month."-".$endDay;
        $events[$eventsSize]{'event'}{'type'} = 'date';

        $eventsSize++;
    }

    # Extract the reverse day events.

    while($content =~ /(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)\.?\h?(\d{1,2})(?:th)?,?\h(\d{4})/gi){

        my $startDay = $2;

        my $endDay = $startDay + 1;
        my $month = $months{lc$1};

        my $year = $3;

        if($endDay > $mdays{$month}){
          $month += 1;
          $endDay = 1;
        }

        $month = "0".$month if length($month) < 2;
        $startDay = "0".$startDay if length($startDay) < 2;
        $endDay = "0".$endDay if length($endDay) < 2;

        $events[$eventsSize]{'event'}{'timestamp'} = $input[$inputSize]{'email'}{'timestamp'};
        $events[$eventsSize]{'event'}{'timezone'} = $input[$inputSize]{'email'}{'timezone'};
        $events[$eventsSize]{'event'}{'start'} = $year."-".$month."-".$startDay;
        $events[$eventsSize]{'event'}{'end'} = $year."-".$month."-".$endDay;
        $events[$eventsSize]{'event'}{'type'} = 'date';

        $eventsSize++;
    }

    $inputSize++;

  }
}

# Close the input file.

close($inputFile);

printToOutputFile();

sub printToOutputFile {

  open (my $outFile, ">output.json") || die "Error in opening the file";

  my $eventsize = @events-1;
  my $eventCount = 0;
  my $dtEventCount = 0;
  my $dEventCount = 0;

  for(my $i = 0; $i <= $eventsize; $i++){

    print $outFile "\t{\n";
    print $outFile "\t\t".'"start" : {'."\n";
    if($events[$i]{'event'}{'type'} eq 'datetime'){
      print $outFile "\t\t\t".'"datetime": '.'"';
      $dtEventCount++;
    } else {
      print $outFile "\t\t\t".'"date": '.'"';
      $dEventCount++;
    }
    print $outFile $events[$i]{'event'}{'start'}.'"';
    print $outFile ",\n" if $eventCount <= $eventsize;
    print $outFile "\t\t\t".'"timezone": '.'"'.$events[$i]{'event'}{'timezone'}.'"'."\n";
    print $outFile "\t\t}";
    print $outFile ",\n" if $eventCount <= $eventsize;
    print $outFile "\t\t".'"end" : {'."\n";
    print $outFile "\t\t\t".'"datetime": '.'"'.$events[$i]{'event'}{'end'}.'"';
    print $outFile ",\n" if $eventCount <= $eventsize;
    print $outFile "\t\t\t".'"timezone": '.'"'.$events[$i]{'event'}{'timezone'}.'"'."\n";
    print $outFile "\t\t}";
    print $outFile "\n" if $eventCount <= $eventsize;
    print $outFile "\t}";
    print $outFile "," if $eventCount <= $eventsize -1;
    print $outFile "\n";

    $eventCount++;

  }

  print $outFile "]\n";
  close($outFile);

  print "\nWe found:\n\n";
  print "$dtEventCount events with a datetime format.\n";
  print "$dEventCount events with a date format.\n\n";
  print "Please see the file output.json for full results.\n\n";
  print "Thank you for using the eventExtractor!\n";
}


# Debug Area

# print Dumper @input;
# print Dumper @events;

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
