#!/usr/bin/perl

use strict;
use Test::More tests => 2;

use File::Temp qw(tempfile);

(undef, my $temp) = tempfile();

system(qq{ $^X -Mblib t/tracksource.pl 2> $temp });
open(FILE, $temp) || die("Can't read $temp\n");
undef $/;
my $data = <FILE>;
close(FILE);
is_deeply($data, q{Tracked objects by class:
FOO                                      1

Sources of leaks:
FOO
  line: 00008   t/tracksource.pl
}, "can track a single leak to its source");

system(qq{ $^X -Mblib t/tracksource2.pl 2> $temp });
open(FILE, $temp) || die("Can't read $temp\n");
undef $/;
my $data = <FILE>;
close(FILE);
is_deeply($data,
q{Tracked objects by class:
Devel::Leak::Object::Tests::tracksource  1
FOO                                      2
LOOPYFOO                                 3

Sources of leaks:
Devel::Leak::Object::Tests::tracksource
  line: 00005   t/tracksource.pm
FOO
  line: 00010   t/tracksource2.pl
  line: 00012   t/tracksource2.pl
LOOPYFOO
  line: 00017   t/tracksource2.pl
  line: 00017   t/tracksource2.pl
  line: 00017   t/tracksource2.pl
},
"can track multiple leak sources in multiple files");
