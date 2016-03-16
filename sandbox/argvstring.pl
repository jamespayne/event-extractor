#!/usr/bin/env perl

use strict;
use warnings;

# Some string comparison tests with @ARGV

if ($ARGV[0] != "test"){
  print "You got the right keyword.\n";
} else {
  print "Thats not the right keyword! Try again.\n\n";
}

print "Second try with regular expressions\n\n";

if ($ARGV[0] =~ /test/g){
  print "You got the right keyword.\n";
} else {
  print "Thats not the right keyword! Try again.\n";
}

# This needs some more exploration.
