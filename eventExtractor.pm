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

my @content = ();

# Remove any newlines, horizontal whitespace and push it into an array.

while (<$fh>) {
  chomp $_;
  $_ =~ s/\h+/ /g;
  push(@content, $_);
}

# Close the file immediately. Keep it clean!

close($fh);

# Extract the data and convert it to an array of hashes.

my @data = ();

foreach my $item(@content){
  if ($item =~ /sent/) {
    $item =~ s/: / => /g;
    push (@data, "{".$item);
  }
  if ($item =~ /timeZone/) {
    $item =~ s/: / => /g;
    push (@data,$item);
  }
  if ($item =~ /content/) {
    $item =~ s/: / => /g;
    push (@data,$item."},");
  }
}

# Debug Area

# print @data;

# Test to see if data can be extracted and formatted

foreach my $item(@data) {
  print $item;
}

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
