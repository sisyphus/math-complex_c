use warnings;
use strict;
use Math::Complex_C qw(:all);

print "1..14\n";

my $eps = 1e-12;

my $rop = Math::Complex_C::Long->new();
my $op = Math::Complex_C::Long->new(4.3, -5.7);

conj_cl($rop, $op);

if(approx(real_cl($rop), 4.3, $eps)) {print "ok 1\n"}
else {
  warn "1: \$rop: $rop\n";
  print "not ok 1\n";
}

if(approx(imag_cl($rop), 5.7, $eps)) {print "ok 2\n"}
else {
  warn "2: \$rop: $rop\n";
  print "not ok 2\n";
}

proj_cl($rop, $op);

# For some versions of glibc (pre 2.12.0), cprojl will incorrectly
# return (0.165448249326664 -0.219315121200462)

if(approx(real_cl($rop), 4.3, $eps)) {print "ok 3\n"}
elsif(approx(real_cl($rop), 0.165448249326664, $eps) &&
      approx(imag_cl($rop), -0.219315121200462, $eps)) {
  warn "\nSkipping tests 3 & 4 - your glibc contains a bug that breaks cprojl()\n",
       "Updating your glibc to version 2.12.0 or later should fix the problem\n";
  print "ok 3\n";
}
else {
  warn "3: \$rop: $rop\n";
  print "not ok 3\n";
}

if(approx(imag_cl($rop), -5.7, $eps)) {print "ok 4\n"}
elsif(approx(real_cl($rop), 0.165448249326664, $eps) &&
      approx(imag_cl($rop), -0.219315121200462, $eps)) {print "ok 4\n"}
else {
  warn "4: \$rop: $rop\n";
  print "not ok 4\n";
}

##############################
##############################
my $nan = get_nanl();
my $inf = get_infl();

assign_cl($op, $inf, 1);

proj_cl($rop, $op);

if(is_infl(real_cl($rop))) {print "ok 5\n"}
else {
  warn "5: \$rop: $rop\n";
  print "not ok 5\n";
}

my $sz = imag_cl($rop);

if("$sz" eq "0") {print "ok 6\n"}
else {
  warn "6: \$rop: $rop\n";
  print "not ok 6\n";
}

##############################
##############################

assign_cl($op, $inf, -1);

proj_cl($rop, $op);

if(is_infl(real_cl($rop))) {print "ok 7\n"}
else {
  warn "7: \$rop: $rop\n";
  print "not ok 7\n";
}

$sz = imag_cl($rop);

if(is_neg_zero($sz)) {print "ok 8\n"}
else {
  warn "8: \$rop: $rop\n";
  print "not ok 8\n";
}

##############################
##############################

assign_cl($op, $inf, $nan);

proj_cl($rop, $op);

if(is_infl(real_cl($rop))) {print "ok 9\n"}
else {
  warn "9: \$rop: $rop\n";
  print "not ok 9\n";
}

$sz = imag_cl($rop);
if("$nan" =~ /^\-/) {
  if(is_neg_zero($sz)) {print "ok 10\n"}
  else {
    warn "10: \$rop: $rop\n\$nan: $nan\n";
    print "not ok 10\n";
  }
}
else {
  if("$sz" eq "0") {print "ok 10\n"}
  else {
    warn "10: \$rop: $rop\n\$nan: $nan\n";
    print "not ok 10\n";
  }
}

##############################
##############################

assign_cl($op, $nan, $inf);

proj_cl($rop, $op);

if(is_infl(real_cl($rop))) {print "ok 11\n"}
else {
  warn "11: \$rop: $rop\n";
  print "not ok 11\n";
}

$sz = imag_cl($rop);

if("$sz" eq "0") {print "ok 12\n"}
else {
  warn "12: \$rop: $rop\n";
  print "not ok 12\n";
}

##############################
##############################

assign_cl($op, $nan, $inf * -1);

proj_cl($rop, $op);

if(is_infl(real_cl($rop))) {print "ok 13\n"}
else {
  warn "13: \$rop: $rop\n";
  print "not ok 13\n";
}

$sz = imag_cl($rop);

if(is_neg_zero($sz)) {print "ok 14\n"}
else {
  warn "14: \$rop: $rop\n";
  print "not ok 14\n";
}

##############################
##############################

sub approx {
    if(($_[0] > ($_[1] - $_[2])) && ($_[0] < ($_[1] + $_[2]))) {return 1}
    return 0;
}

