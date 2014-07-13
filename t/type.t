use warnings;
use strict;
use Config;
use Math::Complex_C qw(:all);

print "1..10\n";

my $s_nv = Math::Complex_C::_nvsize();
my $s_iv = Math::Complex_C::_ivsize();
my $s_d = Math::Complex_C::_doublesize();
my $s_ld = Math::Complex_C::_longdoublesize();
my $s_d_C = Math::Complex_C::_double_Complexsize();
my $s_ld_C = Math::Complex_C::_longdouble_Complexsize();

warn "  Configuration details:\n",
     "   NV size is $s_nv\n",
     "   IV size is $s_iv\n",
     "   double size is $s_d\n",
     "   long double size is $s_ld\n",
     "   double _Complex size is $s_d_C\n",
     "   long double _Complex size is $s_ld_C\n";

my $c_type = Math::Complex_C::_complex_type();

if($c_type eq 'double _Complex') {print "ok 1\n"}
else {
  warn "\$c_type: $c_type\n";
  print "not ok 1\n";
}

my $d_type = Math::Complex_C::_double_type();

if($d_type eq "double") {print "ok 2\n"}
else {
  warn "\$d_type: $d_type\n";
  print "not ok 2\n";
}

if($Config::Config{nvsize} == $s_nv) {print "ok 3\n"}
else {
  warn "\$Config{nvsize}: $Config::Config{nvsize}\n\$s_nv: $s_nv\n";
  print "not ok 3\n";
}

if($Config::Config{ivsize} == $s_iv) {print "ok 4\n"}
else {
  warn "\$Config{ivsize}: $Config::Config{ivsize}\n\$s_iv: $s_iv\n";
  print "not ok 4\n";
}

my $cc = Math::Complex_C->new(17.3, -18.9);
my $ccl = Math::Complex_C::Long->new(17.3, -18.9);

my $root = sqrt($cc);
my $rootl = sqrt($ccl);

my $rc = real_c($root);
my $rcl = real_cl($rootl);
my $ic = imag_c($root);
my $icl = imag_cl($rootl);

if(
    $s_ld_C > $s_d_C &&
    $s_ld   > $s_d   &&
    $s_nv   > $s_d
  ) {
  unless($rc == $rcl && $ic == $icl) {print "ok 5\n"}
  else {
    warn "if:\n\$rc: $rc\n\$rcl: $rcl\n\$ic: $ic\n\$icl: $icl\n";
    print "not ok 5\n";
  }
}
elsif(
    $s_ld_C >  $s_d_C      &&
    $s_ld   >  $s_d        &&
    $s_ld   == $s_ld_C / 2 &&
    $s_d    == $s_d_C  / 2 &&
    $s_nv   == $s_d
  ) {
  #if($rc == $rcl && $ic == $icl) {print "ok 5\n"} # this changed with 0.07.
                                                   # $cc and $ccl are equivalent for 0.06 and earlier,
                                                   # but different for 0.07 and later - when Long->new()
                                                   # began using strtold() to assign Long values for
                                                   # perls where _nsize() != _longdouble size().
  unless($rc == $rcl && $ic == $icl) {print "ok 5\n"}
  else {
    warn "elsif:\n\$rc: $rc\n\$rcl: $rcl\n\$ic: $ic\n\$icl: $icl\n";
    print "not ok 5\n";
  }
}
else {
  warn "Skipping test 5 for this configuration of perl\n";
  print "ok 5\n";
}

my $cl_type = Math::Complex_C::Long::_complex_type();

if($cl_type eq 'long double _Complex') {print "ok 6\n"}
else {
  warn "\$c_type: $c_type\n";
  print "not ok 6\n";
}

my $dl_type = Math::Complex_C::Long::_double_type();

if($dl_type eq "long double") {print "ok 7\n"}
else {
  warn "\$d_type: $d_type\n";
  print "not ok 7\n";
}

my $p_type = Math::Complex_C::_which_package($cc);

if($p_type eq "Math::Complex_C") {print "ok 8\n"}
else {
  warn "\$p_type: $p_type\n";
  print "not ok 8\n";
}

$p_type = Math::Complex_C::_which_package($ccl);

if($p_type eq "Math::Complex_C::Long") {print "ok 9\n"}
else {
  warn "\$p_type: $p_type\n";
  print "not ok 9\n";
}

$p_type = Math::Complex_C::_which_package($dl_type);

if($p_type eq "Not an object") {print "ok 10\n"}
else {
  warn "\$p_type: $p_type\n";
  print "not ok 10\n";
}

__END__
my $s_nv = Math::Complex_C::_nvsize();
my $s_iv = Math::Complex_C::_ivsize();
my $s_d = Math::Complex_C::_doublesize();
my $s_ld = Math::Complex_C::_longdoublesize();
my $s_d_C = Math::Complex_C::_double_Complexsize();
my $s_ld_C = Math::Complex_C::_longdouble_Complexsize();
