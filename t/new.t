use warnings;
use strict;
use Math::Complex_C qw(:all);

print "1..3\n";

my $nan = Math::Complex_C->new();

if(is_nan(real_c($nan)) && is_nan(imag_c($nan))) {print "ok 1\n"}
else {
  warn "1: \$nan: $nan\n";
  print "not ok 1\n";
}

my $c = Math::Complex_C->new(5);

if(real_c($c) == 5 && imag_c($c) == 0) {print "ok 2\n"}
else {
  warn "2: \$c: $c\n";
  print "not ok 2\n";
}

my $d = Math::Complex_C->new(15, get_inf());

if(real_c($d) == 15 && is_inf(imag_c($d))) {print "ok 3\n"}
else {
  warn "3: \$d: $d\n";
  print "not ok 3\n";
}
