use warnings;
use strict;

use Math::Complex_C qw(:all);
use Math::BigInt;

my $t = 8;
print "1..$t\n";

eval{require Math::LongDouble;};

unless($@) {
  my $cl       = Math::Complex_C::Long->new();
  my $real     = Math::LongDouble->new(2);
  my $imag     = Math::LongDouble->new(0);
  my $receiver = Math::LongDouble->new(0);

  my $root = sqrt($real);

  $real *= Math::LongDouble->new(-1);

  LD2cl($cl, $real, $imag);

  $cl = sqrt($cl);

  real_cl2LD($receiver, $cl);
  if($receiver == Math::LongDouble->new(0)) { print "ok 1\n" }
  else {
    warn "\$receiver: $receiver\n";
    print "not ok 1\n";
  }

  imag_cl2LD($receiver, $cl);
  if($receiver == $root) { print "ok 2\n" }
  else {
    warn "\$receiver: $receiver\n";
    print "not ok 2\n";
  }

  my $wrong_obj = Math::BigInt->new();
  my $wrong_var;

  eval{LD2cl($cl, $wrong_obj, $wrong_obj);};

  if($@ =~ /Both 2nd and 3rd args supplied to LD2cl/) {print "ok 3\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 3\n";
  }

  eval{LD2cl($cl, $wrong_var, $wrong_var);};

  if($@ =~ /Both 2nd and 3rd args supplied to LD2cl/) {print "ok 4\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 4\n";
  }

  eval{imag_cl2LD($wrong_obj, $cl);};

  if($@ =~ /1st arg \(a Math::BigInt object\) supplied to imag_cl2LD/) {print "ok 5\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 5\n";
  }

  eval{real_cl2LD($wrong_obj, $cl);};

  if($@ =~ /1st arg \(a Math::BigInt object\) supplied to real_cl2LD/) {print "ok 6\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 6\n";
  }

  eval{imag_cl2LD($wrong_var, $cl);};

  if($@ =~ /1st arg \(which needs to be a Math::LongDouble object\) supplied to imag_cl2LD/) {print "ok 7\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 7\n";
  }

  eval{real_cl2LD($wrong_var, $cl);};

  if($@ =~ /1st arg \(which needs to be a Math::LongDouble object\) supplied to real_cl2LD/) {print "ok 8\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 8\n";
  }

}
else {
  warn "Skipping all tests - couldn't load Math::LongDouble\n";
  for(1 .. $t) {print "ok $_\n"}
}
