use warnings;
use strict;

use Math::Complex_C qw(:all);

print "1..22\n";

my $init_prec = Math::Complex_C::Long::_LDBL_DIG() || 18;


if(long_get_prec() == $init_prec) {print "ok 1\n"}
else {
  warn "Precision: ", long_get_prec(), "\n";
  print "not ok 1\n";
}

long_set_prec(17);

if(long_get_prec() == 17) {print "ok 2\n"}
else {
  warn "Precision: ", long_get_prec(), "\n";
  print "not ok 2\n";
}

my $cl = Math::Complex_C::Long->new(17.5, -1010.25);
my($r, $i) = ld_to_str($cl);

if($r =~ /^1\.7500000000000000\D/) {print "ok 3\n"}
else {
  warn "3: real: *$r*\n";
  print "not ok 3\n";
}

if($i =~ /^\-1\.0102500000000000\D/) {print "ok 4\n"}
else {
  warn "4: imag: *$i*\n";
  print "not ok 4\n";
}

long_set_prec(14);

($r, $i) = ld_to_str($cl);

if($r =~ /^1\.7500000000000\D/) {print "ok 5\n"}
else {
  warn "5: real: *$r*\n";
  print "not ok 5\n";
}

if($i =~ /^\-1\.0102500000000\D/) {print "ok 6\n"}
else {
  warn "6: imag: *$i*\n";
  print "not ok 6\n";
}

($r, $i) = ld_to_strp($cl, 11);

if($r =~ /^1\.7500000000\D/) {print "ok 7\n"}
else {
  warn "7: real: *$r*\n";
  print "not ok 7\n";
}

if($i =~ /^\-1\.0102500000\D/) {print "ok 8\n"}
else {
  warn "8: imag: *$i*\n";
  print "not ok 8\n";
}

($r, $i) = ld_to_str($cl);

if($r =~ /^1\.7500000000000\D/) {print "ok 9\n"}
else {
  warn "9: real: *$r*\n";
  print "not ok 9\n";
}

if($i =~ /^\-1\.0102500000000\D/) {print "ok 10\n"}
else {
  warn "10: imag: *$i*\n";
  print "not ok 10\n";
}

if(d_get_prec() == 15) {print "ok 11\n"}
else {
  warn "Precision: ", long_get_prec(), "\n";
  print "not ok 11\n";
}

d_set_prec(13);

if(d_get_prec() == 13) {print "ok 12\n"}
else {
  warn "Precision: ", long_get_prec(), "\n";
  print "not ok 12\n";
}

my $c = Math::Complex_C->new(-23.625, -2.125);

eval{($r, $i) = ld_to_str($c);};

if($@ =~ /^ld_to_str function needs a Math::Complex_C::Long arg but was supplied with a Math::Complex_C arg/) {print "ok 13\n"}
else {
  warn "\$\@: $@\n";
  print "not ok 13\n";
}

eval{($r, $i) = ld_to_strp($c, 10);};

if($@ =~ /^ld_to_strp function needs a Math::Complex_C::Long arg but was supplied with a Math::Complex_C arg/) {print "ok 14\n"}
else {
  warn "\$\@: $@\n";
  print "not ok 14\n";
}

eval{($r, $i) = d_to_str($cl);};

if($@ =~ /^d_to_str function needs a Math::Complex_C arg but was supplied with a Math::Complex_C::Long arg/) {print "ok 15\n"}
else {
  warn "\$\@: $@\n";
  print "not ok 15\n";
}

eval{($r, $i) = d_to_strp($cl, 10);};

if($@ =~ /^d_to_strp function needs a Math::Complex_C arg but was supplied with a Math::Complex_C::Long arg/) {print "ok 16\n"}
else {
  warn "\$\@: $@\n";
  print "not ok 16\n";
}

($r, $i) = d_to_str($c);

if($r =~ /^\-2\.362500000000\D/) {print "ok 17\n"}
else {
  warn "17: real: *$r*\n";
  print "not ok 17\n";
}

if($i =~ /^\-2\.125000000000\D/) {print "ok 18\n"}
else {
  warn "18: imag: *$i*\n";
  print "not ok 18\n";
}

($r, $i) = d_to_strp($c, 9);

if($r =~ /^\-2\.36250000\D/) {print "ok 19\n"}
else {
  warn "19: real: *$r*\n";
  print "not ok 19\n";
}

if($i =~ /^\-2\.12500000\D/) {print "ok 20\n"}
else {
  warn "20: imag: *$i*\n";
  print "not ok 20\n";
}


($r, $i) = d_to_str($c);

if($r =~ /^\-2\.362500000000\D/) {print "ok 21\n"}
else {
  warn "21: real: *$r*\n";
  print "not ok 21\n";
}

if($i =~ /^\-2\.125000000000\D/) {print "ok 22\n"}
else {
  warn "22: imag: *$i*\n";
  print "not ok 22\n";
}
