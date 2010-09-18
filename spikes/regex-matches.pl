#!/usr/bin/perl

# $Id$

my $config_string = '\A\d+\.\d+(_\d+)?\z || \A\d+\.\d+\.\d+\z || \A\d+\.\d+\.\d+\z';

my @amount = $config_string =~ m/\s+(\|\|)\s+/g;

print "\$amount = ".scalar @amount."\n";