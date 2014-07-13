use warnings;
use strict;

print "1..1\n";

use Math::Complex_C qw(:all);

my $nz = Math::Complex_C::_get_neg_zero();
my $ok = '';

unless(is_neg_zero($nz)) {
  warn "\nYour compiler handles signed zeroes in an unexpected (incorrect ?) way.\n",
       "This will cause this test to fail, and may cause other tests in relation to the sign of zero to fail\n",
       "Feel free to ignore these failures if you're not concerned about the sign of zero\n";
}
else {$ok .= 'a'}

unless(is_neg_zero("hello")) {$ok .= 'b'}
unless(is_neg_zero(1)) {$ok .= 'c'}
unless(is_neg_zero(1.1)){$ok .= 'd'}
unless(is_neg_zero(0.0)){$ok .= 'e'}

if($ok eq 'abcde') {print "ok 1\n"}
else {
  warn "\$ok: $ok\n";
  print "not ok 1\n";
}
