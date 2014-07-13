use warnings;
use strict;
use Math::Complex_C qw(:all);

my $op = new Math::Complex_C(5, 4.5);

my $eps = 1e-12;

print "1..3\n";

my $nv = arg_c($op);

if(approx($nv, 7.3281510178650655e-1, $eps)) {print "ok 1\n"}
else {
  warn "1: \$nv: $nv\n";
  print "not ok 1\n";
}

$nv = abs_c($op);

if(approx($nv, 6.7268120235368549, $eps)) {print "ok 2\n"}
else {
  warn "2: \$nv: $nv\n";
  print "not ok 2\n";
}

$nv = abs($op);

if(approx($nv, 6.7268120235368549, $eps)) {print "ok 3\n"}
else {
  warn "3: \$nv: $nv\n";
  print "not ok 3\n";
}

##############################
##############################

sub approx {
    if(($_[0] > ($_[1] - $_[2])) && ($_[0] < ($_[1] + $_[2]))) {return 1}
    return 0;
}




