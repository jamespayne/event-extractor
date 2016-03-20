#!/usr/bin/env perl

# Array of hashes test.

my $date = "2016-05-01T11:00:00.00Z";
my $timeZone = "Australia/Melbourne";
my $content = "We're pleased to be working with RMIT LINK's Orientation team and RUSU to welcome all new students to campus through a series of exciting Orientation events. This email serves as a notification to make sure you know when the major events are occurring, to ensure they don't interrupt your work and so that you are able to encourage all new students to attend. Brunswick All Students Welcome, 23 February 12 - 1:30pm Brunswick Courtyard. Bundoora All Students Welcome, 24 February 12 - 2pm Bundoora West concourse. City All Students Welcome, 25 February 11am - 2:30pm Alumni Courtyard, University Way. RUSU Welcome Bash, 25 February 4pm - 9pm Alumni Courtyard. City Clubs Day, 3 March 11am - 2pm Alumni Courtyard, University Way.";

my %tmp = ();
my @array = ();
my $arrayLength = @array;

$array[0]{'date'} = $date;
$array[0]{'timeZone'} = $timeZone;
$array[0]{'content'} = $content;

for(my $i; $i <= $arrayLength; $i++){
  print $array[$i]{'date'}."\n";
  print $array[$i]{'timeZone'}."\n";
  print $array[$i]{'content'}."\n";
}

print @array;
