use strict;
use warnings;
use Math::Complex_C::L qw(:all);

print "1..5\n";

my $c1 = MCL(2.1,-5.1);

if(sprintf("%s", $c1) eq Math::Complex_C::L::_overload_string($c1, 0, 0)) {print "ok 1\n"}
else {
  warn "\n$c1 ne ", Math::Complex_C::L::_overload_string($c1, 0, 0), "\n";
  print "not ok 1\n";
}

my $ret = l_to_str($c1);
my $check = sprintf("%s", $c1);

# Remove trailing zeroes from $ret and $check.

$ret =~ s/0+e/e/gi;
$check =~ s/0+e/e/gi;

if("($ret)" eq $check) {print "ok 2\n"}
else {
  warn "\n($ret) ne $check\n";
  print "not ok 2\n";
}

my $str1 = l_to_str(MCL());
my $str2 = l_to_strp(MCL(), 2 + l_get_prec());

if($str1 eq $str2 && $str1 eq 'nan nan') {print "ok 3\n"}
else {
  warn "\nExpected 'nan nan'\nGot '$str1' and '$str2'\n";
  print "not ok 3\n";
}

my $cinf = (MCL(1, 1) / MCL(0, 0));

$str1 = l_to_str($cinf);
$str2 = l_to_strp($cinf, 2 + l_get_prec());

if($str1 eq $str2 && $str1 eq 'inf inf') {print "ok 4\n"}
else {
  warn "\nExpected 'inf inf'\nGot '$str1' and '$str2'\n";
  print "not ok 4\n";
}

$cinf *= MCL(-1, 0);

$str1 = l_to_str($cinf);
$str2 = l_to_strp($cinf, 2 + l_get_prec());

if($str1 eq $str2 && $str1 eq '-inf -inf') {print "ok 5\n"}
else {
  warn "\nExpected '-inf -inf'\nGot '$str1' and '$str2'\n";
  print "not ok 5\n";
}

