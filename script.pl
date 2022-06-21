#!/usr/bin/env perl

use strict;
use warnings;

my $file = 'access.log';
open my $fh, $file or die "Could not open $file: $!";
my %ips;
my @bad;
while(my $line = <$fh>) {
    if($line =~ /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) /) {
        $ips{$1}++;
    }
    my $n = 0;
    # #1
    if($line =~ / "Python-urllib\//) {
        $n++;
    }
    # #2
    if($line =~ / "GET \S+sqlite/i) {
        $n++;
    }
    # #3
    if($line =~ / "GET \S+proxy/i) {
        $n++;
    }
    # #4
    if($line =~ / "GET https?:\/\//) {
        $n++;
    }
    # #5
    if($line =~ /" 400 \d+ /) {
        $n++;
    }
    # #6
    if($line =~ /" 499 0 /) {
        $n++;
    }
    # #7
    if($line =~ / "Cloud mapping experiment/) {
        $n++;
    }
    # #8
    if($line =~ / "PROPFIND /) {
        $n++;
    }
    if($n >= 2) {
        push @bad, $line;
    }
}
close $fh;

my $i = 0;
print "1. Top 10 IP\n";
foreach my $ip (sort {$ips{$b} <=> $ips{$a}} keys %ips) {
    print "$ip\n";
    ## With query number
    #print "$ip $ips{$ip}\n";
    $i++;
    if($i >= 10) {
        last;
    }
}
print "\n2. Bad queries\n";
foreach my $line (@bad) {
    print $line;
}
