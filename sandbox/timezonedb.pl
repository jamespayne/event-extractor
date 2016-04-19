#!/usr/bin/env perl
# print curl -s

use Data::Dumper;
use Date::Parse;

my $eventTime = "2016-02-25T16:00:00Z";
print str2time($eventTime);
my $timeZone = "Asia/Tokyo";

my ($url) = 'http://api.timezonedb.com/?zone='.$timeZone.'&time='.str2time($eventTime).'&format=json&key=5UVEM3ZMSZHG';

my ($time) = `curl -s "$url"` =~ /timestamp":(\d.*)}/gi;

# print Dumper $time;
# print Dumper localtime($time);

my ($S, $M, $H, $d, $m, $Y) = localtime($time);
$m += 1;
$Y += 1900;
my $convertedTime = sprintf("%04d-%02d-%02dT%02d:%02d:%02d.00Z", $Y,$m, $d, $H, $M, $S);

print "Original event time: $eventTime\n";
print "Converted time: $convertedTime\n";


# print Dumper $timezoneData;

# print $timezoneData;

# foreach $item(@timezoneData){
#   print "$item\n";
# }

# print $timezoneData[1];

# my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($timezoneData[1]);
#
# my $formatted_time = time2str("%D", $timezoneData[1]);
#
# print $formatted_time;

# print localtime;
