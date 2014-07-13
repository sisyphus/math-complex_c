use warnings;
use strict;
use Math::Complex_C qw(:all);

print "1..2\n";

warn "\nFYI:\n  DBL_DIG = ", Math::Complex_C::_DBL_DIG(), "\n LDBL_DIG = ", Math::Complex_C::Long::_LDBL_DIG(), "\n";

if($Math::Complex_C::VERSION eq '0.11' && Math::Complex_C::_get_xs_version() eq $Math::Complex_C::VERSION) {print "ok 1\n"}
else {print "not ok 1 $Math::Complex_C::VERSION ", Math::Complex_C::_get_xs_version(), "\n"}

if($Math::Complex_C::Long::VERSION eq '0.11' && Math::Complex_C::Long::_get_xs_version() eq $Math::Complex_C::Long::VERSION) {print "ok 2\n"}
else {print "not ok 2 $Math::Complex_C::Long::VERSION ", Math::Complex_C::Long::_get_xs_version(), "\n"}

