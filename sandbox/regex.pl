#!/usr/bin/env perl
# local $/=undef;
#
# $string = " cat";
#
# $string =~ s/\n\r\t\s//g;
#
# print "$string";

# Date Cleaner

$fwdTextDateMatch = '';

my $text = "We're pleased to be working with RMIT LINK's Orientation team and RUSU to welcome all new students to campus through a series of exciting Orientation events. This email serves as a notification to make sure you know when the major events are occurring, to ensure they don't interrupt your work and so that you are able to encourage all new students to attend. Brunswick All Students Welcome, 23 February 12 - 1:30pm Brunswick Courtyard. Bundoora All Students Welcome, 24 February 12 - 2pm Bundoora West concourse. City All Students Welcome, 25 February 11am - 2:30pm Alumni Courtyard, University Way. RUSU Welcome Bash, 25 February 4pm - 9pm Alumni Courtyard. City Clubs Day, 3 March 11am - 2pm Alumni Courtyard, University Way.";

$text = $text =~ s/\h//g

print $text;

# while($text =~ /(\d\d?)(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept?|october|oct|november|nov|december|dec)\.?(\d{0,23}:?\d\d)(am|pm)?-(\d{0,23}:?\d\d?)(am|pm)?/gi){
#   print pos $text."\";
# }
#
# # my @array = split(//, $text);
# #
# # foreach my $item(@array){
# #   if($item =~ /(\d\d?)\h(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept?|october|oct|november|nov|december|dec)\.?\h(\d{0,23}:?\d\d)(am|pm)?\h?-?\h(\d{0,23}:?\d\d?)(am|pm)?/gi){
# #     print $item;
# #   }
# # }
