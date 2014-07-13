use warnings;
use strict;

print "1..2\n";

use Math::Complex_C qw(:all);

my $zero = Math::Complex_C->new(0.0, 0.0);
my $rop = Math::Complex_C->new();

mul_c_nv($rop, $zero, -1.1);

my $re = real_c($rop);
my $im = imag_c($rop);

my $correct = 0;

if(is_neg_zero($re)) {
  $correct = 1;
  print "ok 1\n";
}
else {
  warn "\n  \$re: $re (correct result is '-0')\n";
  print "not ok 1\n";
}

if(is_neg_zero($im)) {
  print "ok 2\n";
}
elsif($correct && "$im" eq "0") {
  warn "\n  \$im: $im\n";
  warn " Skipping test 2 - this is a known bug with some (old) compilers\n";
  warn " Correct result is '-0'\n";
  print "ok 2\n";
}
else {
  warn "\n  \$im: $im (correct result is '-0')\n";
  print "not ok 2\n";
}

