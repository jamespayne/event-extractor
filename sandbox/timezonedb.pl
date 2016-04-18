#!/usr/bin/env perl
print curl -s `"http://api.timezonedb.com/?zone=Australia/Melbourne&format=json&key=5UVEM3ZMSZHG"`;

my @timezoneData = split(/".?"/, `curl -s "http://api.timezonedb.com/?zone=Australia/Melbourne&format=json&key=5UVEM3ZMSZHG"` );

# print $timezoneData;

foreach $item(@timezoneData){
  print "$item\n";
}
