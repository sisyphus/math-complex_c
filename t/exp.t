use warnings;
use strict;
use Math::Complex_C qw(:all);

my $op = new Math::Complex_C(5, 4.5);
my $rop = Math::Complex_C::new();

my $eps = 1e-12;

print "1..8\n";

exp_c($rop, $op);

if(approx(real_c($rop), -31.2848705190751, $eps)) {print "ok 1\n"}
else {
  warn "1: \$rop: $rop\n";
  print "not ok 1\n";
}

if(approx(imag_c($rop), -145.07833288059, $eps)) {print "ok 2\n"}
else {
  warn "2: \$rop: $rop\n";
  print "not ok 2\n";
}

log_c($rop, $op);

if(approx(real_c($rop), 1.90610133507297, $eps)) {print "ok 3\n"}
else {
  warn "3: \$rop: $rop\n";
  print "not ok 3\n";
}

if(approx(imag_c($rop), 0.732815101786507, $eps)) {print "ok 4\n"}
else {
  warn "4: \$rop: $rop\n";
  print "not ok 4\n";
}

##############################
##############################

$rop = exp($op);

if(approx(real_c($rop), -31.2848705190751, $eps)) {print "ok 5\n"}
else {
  warn "5: \$rop: $rop\n";
  print "not ok 5\n";
}

if(approx(imag_c($rop), -145.07833288059, $eps)) {print "ok 6\n"}
else {
  warn "6: \$rop: $rop\n";
  print "not ok 6\n";
}

$rop = log($op);

if(approx(real_c($rop), 1.90610133507297, $eps)) {print "ok 7\n"}
else {
  warn "7: \$rop: $rop\n";
  print "not ok 7\n";
}

if(approx(imag_c($rop), 0.732815101786507, $eps)) {print "ok 8\n"}
else {
  warn "8: \$rop: $rop\n";
  print "not ok 8\n";
}

##############################
##############################


sub approx {
    if(($_[0] > ($_[1] - $_[2])) && ($_[0] < ($_[1] + $_[2]))) {return 1}
    return 0;
}


