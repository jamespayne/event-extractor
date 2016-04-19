#!/usr/bin/env perl

use IO::Socket::INET;

my $socket = IO::Socket::INET->new(
                PeerAddr => 'api.timezonedb.com',
                PeerPort => 80,
                Proto => 'tcp',
                Type => SOCK_STREAM) or
die "Unable to connect to $serverhost: $!\n";

# Sending data to the server
print $socket "http://api.timezonedb.com?zone=Australia/Melbourne&format=json&key=5UVEM3ZMSZHG";

# Reading data from the server
my $response = <$socket>;
print $response;
close $socket;
