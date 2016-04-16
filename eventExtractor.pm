#!/usr/bin/env perl

# Scripting Langugae Programming Assignment 1
# Perl Email Event Extraction Script by James Payne(s3435992)
# RMIT University 2016

use strict;
use warnings;
use Data::Dumper; # Remember to delete this from final script.


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

    while($content =~ /(\d{1,2})\h$monthsMatch\h(\d{1,2}:?\d?\d?)(?:pm|am)?\h-\h(\d{1,2}:?\d?\d?)(pm|am)?/gi){
      my $day = $1;
      my $month = $months{lc$2};
      my $startHour = $3;
      my $startMinute  = $4;
      my $endHour = $5;
      my $endMinute = $6;

      if(!$startMinute){
        $startMinute = "00";
      }

      if(!$endMinute){
        $endMinute = "00";

      }

      if($startHour > $endHour){
        $endHour += 12;
      } elsif($startHour < $endHour){
        $endHour += 12;
        $startHour += 12;
      }

      $datetimes[$datetimesSize]{'event'}{'timestamp'} = $input[$inputSize]{'email'}{'timestamp'};
      $datetimes[$datetimesSize]{'event'}{'timezone'} = $input[$inputSize]{'email'}{'timezone'};
      $datetimes[$datetimesSize]{'event'}{'start'} = $startHour;
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

open (my $outputFile, ">output.json") || die "Error in opening the file";

print $outputFile "[\n";

# for(my $i = 0; $i < $inputSize; $i++){
#
#   my %months = qw(january 1 jan 1 february 2 feb 3 march 3 mar 3 april 4 apr 4 may 5 june 6 jun 6 july 7 jul 7 august 8 aug 8 september 9 sep 9 sept 9 october 10 oct 10 november 11 nov 11 december 12 dec 12);
#
#   my %hours = qw(1 13 2 14 3 15 4 16 5 17 6 18 7 19 8 20 9 21 10 22 11 23);
#
#   # Extract datetime dates.
#   my $year = 2016;
#
#   my $count = () = $input[$i]{'email'}{'content'} =~ /(\d{1,2})\h(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)\h(\d{1,2}):?(\d?\d?)(?:pm|am)?\h-\h(\d{1,2}):?(\d?\d?)/gi;



  # while($input[$i]{'email'}{'content'} =~ /(\d{1,2})\h(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)\h(\d{1,2}):?(\d?\d?)(?:pm|am)?\h-\h(\d{1,2}):?(\d?\d?)/gi){
  #   my $day = $1;
  #   my $month = $months{lc$2};
  #   my $startHour = $3;
  #   my $startMinute  = $4;
  #   my $endHour = $5;
  #   my $endMinute = $6;
  #   if(!$startMinute){
  #     $startMinute = "00";
  #   }
  #   if(!$endMinute){
  #     $endMinute = "00";
  #
  #   }
  #   if($startHour > $endHour){
  #     $endHour += 12;
  #   } elsif($startHour < $endHour){
  #     $endHour += 12;
  #     $startHour += 12;
  #   }
  #   print $outputFile "\t\t".'"start" : {'."\n";
  #   print $outputFile "\t\t\t".'"dateTime": "'.$year."-".$month."-".$day."T".$startHour.":".$startMinute.'.00Z",'."\n";
  #   print $outputFile "\t\t\t".'"timezone": "'.$input[$i]{'email'}{'timezone'}.'"'."\n";
  #   print $outputFile "\t\t".'},'."\n";
  # }
# }
print $outputFile "]\n";

close($outputFile);
# Debug Area

print Dumper @input;
print Dumper @datetimes;


# Start POD

=pod

=head1 NAME

eventextractor.pm - Perl script to extract events from emails.

=head1 SYNOPSIS

=over 4

= item(1)

eventextractor [options] [inputfile]

=back

=cut
