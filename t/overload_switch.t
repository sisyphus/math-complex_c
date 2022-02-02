# This file created in response to:
# https://github.com/sisyphus/math-decimal64/pull/1,
# which also applies to Math::Complex_C
# Thanks to @hiratara

use strict;
use warnings;
use Math::Complex_C qw(:all);

use Test::More;

END { done_testing(); };

my $two = Math::Complex_C->new(2);

cmp_ok($two - 7, '==', -5, "Math::Complex_C object - IV");
cmp_ok(5 - $two, '==',  3, "IV - Math::Complex_C object");

cmp_ok($two / 2, '==', 1, "Math::Complex_C object / IV");
cmp_ok(8 / $two, '==', 4, "IV / Math::Complex_C object");

cmp_ok(real_c($two ** 6), '>=', _min(64), "1: Math::Complex_C ** IV");
cmp_ok(real_c($two ** 6), '<=', _max(64), "2: Math::Complex_C ** IV");
cmp_ok(real_c(6 ** $two), '>=', _min(36), "1:IV ** Math::Complex_C object");
cmp_ok(real_c(6 ** $two), '<=', _max(36), "2:IV ** Math::Complex_C object");


# These next 2 subs will cause failures here on perl-5.20.0
# and later if &PL_sv_yes or &PL_sv_no is encountered in the
# overload sub.

sub foo () {!0} # Breaks PL_sv_yes
sub bar () {!1} # Breaks PL_sv_no

sub _min { return $_[0] - 1e-10 }
sub _max { return $_[0] + 1e-10 }
