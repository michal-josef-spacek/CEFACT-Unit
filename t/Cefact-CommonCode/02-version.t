use strict;
use warnings;

use Cefact::CommonCode;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Cefact::CommonCode::VERSION, 0.01, 'Version.');
