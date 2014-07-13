use warnings;
use strict;
use Math::Complex_C qw(:all);

print "1..30\n";

my $eps = 1e-12;

my $op = Math::Complex_C->new(2, 2);
my $rop = Math::Complex_C->new();

sin_c($rop, $op);

if(approx(real_c($rop), 3.420954861117, $eps)) {print "ok 1\n"}
else {
  warn "1: \$rop: $rop\n";
  print "not ok 1\n";
}

if(approx(imag_c($rop), -1.50930648532362, $eps)) {print "ok 2\n"}
else {
  warn "2: \$rop: $rop\n";
  print "not ok 2\n";
}

cos_c($rop, $op);

if(approx(real_c($rop), -1.56562583531574, $eps)) {print "ok 3\n"}
else {
  warn "3: \$rop: $rop\n";
  print "not ok 3\n";
}

if(approx(imag_c($rop), -3.29789483631124, $eps)) {print "ok 4\n"}
else {
  warn "4: \$rop: $rop\n";
  print "not ok 4\n";
}

tan_c($rop, $op);

if(approx(real_c($rop), -0.0283929528682323, 0.00000000001)) {print "ok 5\n"}
else {
  warn "5: \$rop: $rop\n";
  print "not ok 5\n";
}

if(approx(imag_c($rop), 1.0238355945704727, 0.00000000001)) {print "ok 6\n"}
else {
  warn "6: \$rop: $rop\n";
  print "not ok 6\n";
}

###################################
###################################

asin_c($rop, $op);

if(approx(real_c($rop), 0.754249144698046, $eps)) {print "ok 7\n"}
else {
  warn "7: \$rop: $rop\n";
  print "not ok 7\n";
}

if(approx(imag_c($rop), 1.73432452148797, $eps)) {print "ok 8\n"}
else {
  warn "8: \$rop: $rop\n";
  print "not ok 8\n";
}

acos_c($rop, $op);

if(approx(real_c($rop), 0.81654718209685, $eps)) {print "ok 9\n"}
else {
  warn "9: \$rop: $rop\n";
  print "not ok 9\n";
}

if(approx(imag_c($rop), -1.73432452148797, $eps)) {print "ok 10\n"}
else {
  warn "10: \$rop: $rop\n";
  print "not ok 10\n";
}

atan_c($rop, $op);

if(approx(real_c($rop), 1.31122326967164, 0.00000000001)) {print "ok 11\n"}
else {
  warn "11: \$rop: $rop\n";
  print "not ok 11\n";
}

if(approx(imag_c($rop), 0.238877861256859, 0.00000000001)) {print "ok 12\n"}
else {
  warn "12: \$rop: $rop\n";
  print "not ok 12\n";
}

#################################
#################################

sinh_c($rop, $op);

if(approx(real_c($rop), -1.50930648532362, $eps)) {print "ok 13\n"}
else {
  warn "13: \$rop: $rop\n";
  print "not ok 13\n";
}

if(approx(imag_c($rop), 3.42095486111701, $eps)) {print "ok 14\n"}
else {
  warn "14: \$rop: $rop\n";
  print "not ok 14\n";
}

cosh_c($rop, $op);

if(approx(real_c($rop), -1.56562583531574, $eps)) {print "ok 15\n"}
else {
  warn "15: \$rop: $rop\n";
  print "not ok 15\n";
}

if(approx(imag_c($rop), 3.29789483631124, $eps)) {print "ok 16\n"}
else {
  warn "16: \$rop: $rop\n";
  print "not ok 16\n";
}

tanh_c($rop, $op);

if(approx(real_c($rop), 1.0238355945704727, 0.00000000001)) {print "ok 17\n"}
else {
  warn "17: \$rop: $rop\n";
  print "not ok 17\n";
}

if(approx(imag_c($rop), -0.0283929528682323, 0.00000000001)) {print "ok 18\n"}
else {
  warn "18: \$rop: $rop\n";
  print "not ok 18\n";
}

###################################
###################################

asinh_c($rop, $op);

if(approx(real_c($rop), 1.73432452148797, $eps)) {print "ok 19\n"}
else {
  warn "19: \$rop: $rop\n";
  print "not ok 19\n";
}

if(approx(imag_c($rop), 0.754249144698046, $eps)) {print "ok 20\n"}
else {
  warn "20: \$rop: $rop\n";
  print "not ok 20\n";
}

acosh_c($rop, $op);

if(approx(real_c($rop), 1.73432452148797, $eps)) {print "ok 21\n"}
else {
  warn "21: \$rop: $rop\n";
  print "not ok 21\n";
}

if(approx(imag_c($rop), 0.81654718209685, $eps)) {print "ok 22\n"}
else {
  warn "22: \$rop: $rop\n";
  print "not ok 22\n";
}

atanh_c($rop, $op);

if(approx(real_c($rop), 0.238877861256859, 0.00000000001)) {print "ok 23\n"}
else {
  warn "23: \$rop: $rop\n";
  print "not ok 23\n";
}

if(approx(imag_c($rop), 1.311223269671635, 0.00000000001)) {print "ok 24\n"}
else {
  warn "24: \$rop: $rop\n";
  print "not ok 24\n";
}

###################################
###################################

$rop = sin($op);

if(approx(real_c($rop), 3.420954861117, $eps)) {print "ok 25\n"}
else {
  warn "25: \$rop: $rop\n";
  print "not ok 25\n";
}

if(approx(imag_c($rop), -1.50930648532362, $eps)) {print "ok 26\n"}
else {
  warn "26: \$rop: $rop\n";
  print "not ok 26\n";
}

$rop = cos($op);

if(approx(real_c($rop), -1.56562583531574, $eps)) {print "ok 27\n"}
else {
  warn "27: \$rop: $rop\n";
  print "not ok 27\n";
}

if(approx(imag_c($rop), -3.29789483631124, $eps)) {print "ok 28\n"}
else {
  warn "28: \$rop: $rop\n";
  print "not ok 28\n";
}

###################################
###################################

my $at = Math::Complex_C->new(2.5, 3.5);

$rop = atan2($op, $at);

if(approx(real_c($rop), 0.579192942598755, 0.00000000001)) {print "ok 29\n"}
else {
  warn "29: \$rop: $rop\n";
  print "not ok 29\n";
}

if(approx(imag_c($rop), -0.0760528436007479, 0.00000000001)) {print "ok 30\n"}
else {
  warn "30: \$rop: $rop\n";
  print "not ok 30\n";
}


sub approx {
    if(($_[0] > ($_[1] - $_[2])) && ($_[0] < ($_[1] + $_[2]))) {return 1}
    return 0;
}



