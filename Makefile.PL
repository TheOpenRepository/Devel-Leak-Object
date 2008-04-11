use strict;
use inc::Module::Install;

name           'Devel-Leak-Object';
all_from       'lib/Devel/Leak/Object.pm';
requires       'Scalar::Util' => '1.19';
test_requires 'Test::More'   => '0.42';

WriteAll;
