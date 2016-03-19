#!/usr/bin/env perl
open (my $fh1, @ARGV[0]) || die "Cannot open the file!\n";
while(<$fh1>){
  print $_;
}
close($fh);
