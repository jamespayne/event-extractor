#!/usr/bin/env perl
local $/=undef;

$string = " cat";

$string =~ s/\n\r\t\s//g;

print "$string";
