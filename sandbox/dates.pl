#!/usr/bin/env perl

# Scripting Langugae Programming Assignment 1
# Perl Email Event Extraction Script by James Payne(s3435992)
# RMIT University 2016

use strict;
use warnings;

# From perldoc.org
# my $mon=9;
# my $mday=18;
# my @abbr = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
#     print "$abbr[$mon] $mday";
    # $mon=9, $mday=18 gives "Oct 18"

my $line = '2016-03-03T19:03:02.00Z';
my ($year, $month, $day, $hours, $minutes, $seconds, $tzd) = $line =~ /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}).(\d{2,4}Z)/;
print "${year}/${month}/${day}, ${hours}:${minutes}:${seconds}, ${tzd}\n";
