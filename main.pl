#!/usr/bin/env perl

# Scripting Langugae Programming Assignment 1
# Perl Email Event Extraction Script by James Payne(s3435992)
# RMIT University 2016

# Sample test script to demonstrate modularisation.

use strict;
use warnings;
use eventExtractor;

if (!$ARGV[0] || @ARGV > 1){
  print "\nYou didn't supply an input file or you have supplied too many\n";
  print "arguments. Please read the documentation!\n\n";
  exit;
}

# Check the file name argument has a .json extension.

if ($ARGV[0] =~ /\.json$/i){
  print "Valid .json file submitted. Thank you.\n";

  # Call the main subroutine in eventExtractor.pm perl module.

  eventExtractor::extractEvents();

} else {
  print "That doesn't appear to be a valid .json file.\n";
  exit;
}
