#!/usr/bin/env perl

# Scripting Langugae Programming Assignment 1
# Perl Email Event Extraction Script by James Payne(s3435992)
# RMIT University 2016

use strict;
use warnings;

# Start main command line checks and file validation.

# Check to see if the required input file has been supplied and there are no
# more than 1 arguments for input.

if (!$ARGV[0] || @ARGV > 1) {
  print "\nYou didn't supply an input file or you have supplied too many\n";
  print "arguments. Please read the documentation!\n\n";
  exit;
}

# Check the file name argument has a .json extension.

if ($ARGV[0] =~ /\.json$/i) {
  print "Valid .json file submitted. Thank you.\n";
} else {
  print "That doesn't appear to be a valid .json file.\n";
  exit;
}

# Create a new filehandler and open the file given as input.

open (my $fh, $ARGV[0]) || die "Error in opening the file";

my @input = ();
my $inputSize = 1;
my @output = ();

# Remove any newlines, horizontal whitespace and push it into an array.

while (<$fh>) {
  if($_ =~ /sent/){
    my ($year, $month, $day, $hours, $minutes, $seconds, $tzd) = $_ =~ /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}).(\d{2,4}Z)/;
    $input[$inputSize]{'year'} = $year;
    $input[$inputSize]{'month'} = $month;
    $input[$inputSize]{'day'} = $day;
    $input[$inputSize]{'hours'} = $hours;
    $input[$inputSize]{'minutes'} = $minutes;
    $input[$inputSize]{'seconds'} = $seconds;
    $input[$inputSize]{'tzd'} = $tzd;
  }
  if($_ =~ /timeZone/){
    my ($timeZone) = $_ =~ /(\w*\/\w*)/;
    $input[$inputSize]{'timeZone'} = $timeZone;
  }
  if($_ =~ /content/){
    my ($content) = $_ =~ /"content": "(.*)"/;
    $input[$inputSize]{'content'} = $1;
    $inputSize++;
  }

}

# Close the file immediately. Keep it clean!

close($fh);

findEvent();

sub findEvent {
  for my $i ( 1 .. $#input ) {
    if ($input[$i]{'content'} =~ /12/) {
      print "Found event!";
    }
  }
}

# Debug Area

# for my $i ( 1 .. $#input ) {
#   print "{\n";
#   print "   Year: ".$input[$i]{'year'}."\n";
#   print "   Month: ".$input[$i]{'month'}."\n";
#   print "   Day: ".$input[$i]{'day'}."\n";
#   print "   Hours: ".$input[$i]{'hours'}."\n";
#   print "   Minute: ".$input[$i]{'minutes'}."\n";
#   print "   Second: ".$input[$i]{'seconds'}."\n";
#   print "   TZD: ".$input[$i]{'tzd'}."\n";
#   print "   Timezone: ".$input[$i]{'timeZone'}."\n" if defined $input[$i]{'timeZone'};
#   print "   Content: ".$input[$i]{'content'}."\n";
#   print "\n}\n";
# }

# Test to see if input can be extracted and formatted

# foreach my $item(@input) {
#   print $item;
# }

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
