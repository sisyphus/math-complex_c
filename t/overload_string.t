use warnings;
use strict;

use Math::Complex_C qw(:all);

print "1..14\n";

my $ca = Math::Complex_C->new();
my $cal = Math::Complex_C::Long->new();

my $str = Math::Complex_C::_overload_string($ca);

if($str eq '(NaN NaN)') {print "ok 1\n"}
else {
  warn "1: \$str: *$str*\n";
  print "not ok 1\n";
}

$str = Math::Complex_C::Long::_overload_string($cal);

if($str eq '(NaN NaN)') {print "ok 2\n"}
else {
  warn "2: \$str: *$str*\n";
  print "not ok 2\n";
}

my $cb = Math::Complex_C->new(get_inf(), get_inf());
my $cbl = Math::Complex_C::Long->new(get_infl(), get_infl());

$str = Math::Complex_C::_overload_string($cb);

if($str eq '(Inf Inf)') {print "ok 3\n"}
else {
  warn "3: \$str: *$str*\n";
  print "not ok 3\n";
}

$str = Math::Complex_C::Long::_overload_string($cbl);

if($str eq '(Inf Inf)') {print "ok 4\n"}
else {
  warn "4: \$str: *$str*\n";
  print "not ok 4\n";
}

$cb *= -1.0;
$cbl *= -1.0;

$str = Math::Complex_C::_overload_string($cb);

if($str eq '(NaN NaN)') {
  warn "\n  Skipping tests 5 & 6 - your compiler/glibc apparently thinks that\n",
         "  inf * -1.0 is nan. (Looks like a compiler/glibc bug to me.)\n";
  print "ok 5\n";
  print "ok 6\n";
}
else {
  if($str eq '(-Inf -Inf)') {print "ok 5\n"}
  else {
    warn "5: \$str: *$str*\n";
    print "not ok 5\n";
  }

  $str = Math::Complex_C::Long::_overload_string($cbl);

  if($str eq '(-Inf -Inf)') {print "ok 6\n"}
  else {
    warn "6: \$str: *$str*\n";
    print "not ok 6\n";
  }
}

my $cc = Math::Complex_C->new(0,0);
my $ccl = Math::Complex_C::Long->new(0,0);

$str = Math::Complex_C::_overload_string($cc);

if($str eq '(0 0)') {print "ok 7\n"}
else {
  warn "7: \$str: *$str*\n";
  print "not ok 7\n";
}

$str = Math::Complex_C::Long::_overload_string($ccl);

if($str eq '(0 0)') {print "ok 8\n"}
else {
  warn "8: \$str: *$str*\n";
  print "not ok 8\n";
}

my $cd = Math::Complex_C->new(-17.625, 81.125);
my $cdl = Math::Complex_C::Long->new('-17.625', '81.125');

my $str1 = Math::Complex_C::_overload_string($cd);
my $str2 = Math::Complex_C::Long::_overload_string($cdl);

if($str1 =~ /^\(\-1\.7625\D/ && $str1 =~ /\s8\.1125\D/) {print "ok 9\n"}
else {
  warn "9: \$str1: *$str1*\n";
  print "not ok 9\n";
}

if($str2 =~ /^\(\-1\.7625\D/ && $str2 =~ /\s8\.1125\D/) {print "ok 10\n"}
else {
  warn "10: \$str2: *$str2*\n";
  print "not ok 10\n";
}

if($str1 eq $str2) {print "ok 11\n"}
else {
  warn "11: \$str1: *$str1* \$str2: *$str2*\n";
  print "not ok 11\n";
}

my $ce = Math::Complex_C->new(1, -2);
my $cel = Math::Complex_C::Long->new(1, -2);

$str1 = Math::Complex_C::_overload_string($ce);
$str2 = Math::Complex_C::Long::_overload_string($cel);

if($str1 eq $str2) {print "ok 12\n"}
else {
  warn "12: \$str1: *$str1* \$str2: *$str2*\n";
  print "not ok 12\n";
}

if($str1 =~ /^\(1\.0\D/ && $str1 =~ /\s\-2\.0\D/) {print "ok 13\n"}
else {
  warn "13: \$str1: $str1\n";
  print "not ok 13\n";
}

if($str2 =~ /^\(1\.0\D/ && $str2 =~ /\s\-2\.0\D/) {print "ok 14\n"}
else {
  warn "14: \$str2: $str2\n";
  print "not ok 14\n";
}
