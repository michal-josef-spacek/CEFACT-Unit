use strict;
use warnings;

use CEFACT::Unit;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = CEFACT::Unit->new;
isa_ok($obj, 'CEFACT::Unit');
