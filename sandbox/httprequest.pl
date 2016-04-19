#!/usr/bin/env perl

use HTTP::Request;
use LWP::UserAgent;

my $request = HTTP::Request->new(GET => 'http://api.timezonedb.com/?zone=Australia/Melbourne&format=json&key=5UVEM3ZMSZHG');

my $ua = LWP::UserAgent->new;
$response = $ua->request($request);

print $response;
