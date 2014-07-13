use warnings;
use strict;

use Math::Complex_C qw(:all);

print "1..6\n";

my $nan = get_nanl();

if($nan != $nan) {print "ok 1\n"}
else {
  warn "\$nan: $nan\n";
  print "not ok 1\n";
}

my $inf = get_infl();

if($inf == $inf) {print "ok 2\n"}
else {
  warn "\$inf: $inf\n";
  print "not ok 2\n";
}

if($inf/$inf != $inf/$inf) {print "ok 3\n"}
else {
  warn "\$inf/\$inf: ", $inf/$inf, "\n";
  print "not ok 3\n";
}

if($inf * -1 == -$inf) {print "ok 4\n"}
else {
  warn "-\$inf: ", -$inf, "\n";
  print "not ok 4\n";
}

my $ninf = $inf * -1;

if(is_infl($ninf) && $ninf < 0) {print "ok 5\n"}
else {
  warn "\$ninf: $ninf\n";
  print "not ok 5\n";
}

if(is_infl($nan)) {print "not ok 6\n"}
else {print "ok 6\n"}
