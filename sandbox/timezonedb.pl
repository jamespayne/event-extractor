#!/usr/bin/env perl
my $timezoneData = `curl -s "http://api.timezonedb.com/?zone=Australia/Melbourne&format=json&key=5UVEM3ZMSZHG"`."\n";

print $timezoneData;
