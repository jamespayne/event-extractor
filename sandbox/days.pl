#!/usr/bin/env perl

use strict;
use warnings;

my @days = (
    {
      'name' => 'monday',
      'altname' => 'mon'
    },
    {
      'name' => 'tuesday',
      'altname' => 'tue'
    },
    {
      'name' => 'wednesday',
      'altname' => 'wed'
    },
    {
      'name' => 'thursday',
      'altname' => 'thurs'
    },
    {
      'name' => 'friday',
      'altname' => 'fri'
    },
    {
      'name' => 'saturday',
      'altname' => 'sat'
    },
    {
      'name' => 'sunday',
      'altname' => 'sun'
    }
);

# for my $i ( 0 .. $#days ) {
#   print scalar ($i + 1)." - ";
#   print $days[$i]{'name'}."\n";
# }

print "Please enter a day: ";
my $input = <>;

if($input = 1..7){
  print $days[$input-1]{name};
}
