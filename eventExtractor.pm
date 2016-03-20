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

my @data = ();
my $dataSize = 1;

# Remove any newlines, horizontal whitespace and push it into an array.

while (<$fh>) {
  if($_ =~ /sent/){
    my ($year, $month, $day, $hours, $minutes, $seconds, $tzd) = $_ =~ /(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}).(\d{2,4}Z)/;
    $data[$dataSize]{'year'} = $year;
    $data[$dataSize]{'month'} = $month;
    $data[$dataSize]{'day'} = $day;
    $data[$dataSize]{'hours'} = $hours;
    $data[$dataSize]{'minutes'} = $minutes;
    $data[$dataSize]{'seconds'} = $seconds;
    $data[$dataSize]{'tzd'} = $tzd;
  }
  if($_ =~ /timeZone/){
    my ($timeZone) = $_ =~ /(\w*\/\w*)/;
    $data[$dataSize]{'timeZone'} = $timeZone;
  }
  if($_ =~ /content/){
    my ($content) = $_ =~ /"content": "(.*)"/;
    $data[$dataSize]{'content'} = $1;
    $dataSize++;
  }

}

# Close the file immediately. Keep it clean!

close($fh);

# Debug Area
for my $i ( 1 .. $#data ) {
  print "{\n";
  print "   Year: ".$data[$i]{'year'}."\n";
  print "   Month: ".$data[$i]{'month'}."\n";
  print "   Day: ".$data[$i]{'day'}."\n";
  print "   Hours: ".$data[$i]{'hours'}."\n";
  print "   Minute: ".$data[$i]{'minutes'}."\n";
  print "   Second: ".$data[$i]{'seconds'}."\n";
  print "   TZD: ".$data[$i]{'tzd'}."\n";
  print "   Timezone: ".$data[$i]{'timeZone'}."\n" if defined $data[$i]{'timeZone'};
  print "   Content: ".$data[$i]{'content'}."\n";
  print "\n}\n";
}

# Test to see if data can be extracted and formatted

# foreach my $item(@data) {
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
