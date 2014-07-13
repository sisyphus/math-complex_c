use warnings;
use strict;
use Math::Complex_C qw(:all);

print "1..54\n";

my $eps = 1e-12;

my $avail = 0;
my $toggle = 1;
eval{require Devel::Peek;};
$avail = 1 unless $@;

my $c1 = Math::Complex_C->new(5, 6);
my $c2 = Math::Complex_C->new(3, 2);

add_c($c2, $c2, $c1);
sub_c($c2, $c2, $c1);

if($c2 == Math::Complex_C->new(3, 2)) {print "ok 1\n"}
else {
  warn "\$c2: $c2\n";
  print "not ok 1\n";
}

add_c_uv($c2, $c2, 17);
sub_c_uv($c2, $c2, 17);

if($c2 == Math::Complex_C->new(3, 2)) {print "ok 2\n"}
else {
  warn "\$c2: $c2\n";
  print "not ok 2\n";
}

add_c_iv($c2, $c2, -17);
sub_c_iv($c2, $c2, -17);

if($c2 == Math::Complex_C->new(3, 2)) {print "ok 3\n"}
else {
  warn "\$c2: $c2\n";
  print "not ok 3\n";
}

add_c_nv($c2, $c2, -17.5);
sub_c_nv($c2, $c2, -17.5);

if($c2 == Math::Complex_C->new(3, 2)) {print "ok 4\n"}
else {
  warn "\$c2: $c2\n";
  print "not ok 4\n";
}

mul_c($c2, $c2, $c1);
div_c($c2, $c2, $c1);

if(approx(real_c($c2), 3, $eps) && approx(imag_c($c2), 2, $eps)) {print "ok 5\n"}
else {
  warn "\$c2: $c2\n";
  print "not ok 5\n";
}

mul_c_uv($c2, $c2, 17);
div_c_uv($c2, $c2, 17);

if(approx(real_c($c2), 3, $eps) && approx(imag_c($c2), 2, $eps)) {print "ok 6\n"}
else {
  warn "\$c2: $c2\n";
  print "not ok 6\n";
}

mul_c_iv($c2, $c2, -17);
div_c_iv($c2, $c2, -17);

if(approx(real_c($c2), 3, $eps) && approx(imag_c($c2), 2, $eps)) {print "ok 7\n"}
else {
  warn "\$c2: $c2\n";
  print "not ok 7\n";
}

mul_c_nv($c2, $c2, -17.5);
div_c_nv($c2, $c2, -17.5);

if(approx(real_c($c2), 3, $eps) && approx(imag_c($c2), 2, $eps)) {print "ok 8\n"}
else {
  warn "\$c2: $c2\n";
  print "not ok 8\n";
}

##################################
##################################
##################################

# $c2 might not be exactly as it was - so we restore it to
# its original value.

assign_c($c2, 3.0, 2.0);

my $c3 = $c2 + $c1;
$c3 = $c3 - $c1;

if($c3 == Math::Complex_C->new(3, 2)) {print "ok 9\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 9\n";
}

$c3 = $c2 + 17;
$c3 = $c3 - 17;

if($c3 == Math::Complex_C->new(3, 2)) {print "ok 10\n"}
else {
  warn "\$c3: $c3\n";
  if($avail && $toggle) {
    warn "Dumping real part of \$c3\n";
    Devel::Peek::Dump(real_c($c3));
    warn "Dumping real part of new(3,2)\n";
    Devel::Peek::Dump(real_c(Math::Complex_C->new(3, 2)));
    warn "Dumping imaginary part of \$c3\n";
    Devel::Peek::Dump(imag_c($c3));
    warn "Dumping imaginary part of new(3,2)\n";
    Devel::Peek::Dump(imag_c(Math::Complex_C->new(3, 2)));
    $toggle = 0; # No more dumps until $toggle is reset.
  }
  print "not ok 10\n";
}

$c3 = $c2 + (-17);
$c3 = $c3 - (-17);

if($c3 == Math::Complex_C->new(3, 2)) {print "ok 11\n"}
else {
  warn "\$c3: $c3\n";
  if($avail && $toggle) {
    warn "Dumping real part of \$c3\n";
    Devel::Peek::Dump(real_c($c3));
    warn "Dumping real part of new(3,2)\n";
    Devel::Peek::Dump(real_c(Math::Complex_C->new(3, 2)));
    warn "Dumping imaginary part of \$c3\n";
    Devel::Peek::Dump(imag_c($c3));
    warn "Dumping imaginary part of new(3,2)\n";
    Devel::Peek::Dump(imag_c(Math::Complex_C->new(3, 2)));
    $toggle = 0; # No more dumps until $toggle is reset.
  }
  print "not ok 11\n";
}

$c3 = $c2 + (-19.25);
$c3 = $c3 - (-19.25);

if($c3 == Math::Complex_C->new(3, 2)) {print "ok 12\n"}
else {
  warn "\$c3: $c3\n";
  if($avail && $toggle) {
    warn "Dumping real part of \$c3\n";
    Devel::Peek::Dump(real_c($c3));
    warn "Dumping real part of new(3,2)\n";
    Devel::Peek::Dump(real_c(Math::Complex_C->new(3, 2)));
    warn "Dumping imaginary part of \$c3\n";
    Devel::Peek::Dump(imag_c($c3));
    warn "Dumping imaginary part of new(3,2)\n";
    Devel::Peek::Dump(imag_c(Math::Complex_C->new(3, 2)));
    $toggle = 0; # No more dumps until $toggle is reset.
  }
  print "not ok 12\n";
}

$toggle = 1; #Reset $toggle.

$c3 = $c2 * $c1;
$c3 = $c3 / $c1;

if(approx(real_c($c3), 3, $eps) && approx(imag_c($c3), 2, $eps)) {print "ok 13\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 13\n";
}

$c3 = $c2 * 17;
$c3 = $c3 / 17;

if(approx(real_c($c3), 3, $eps) && approx(imag_c($c3), 2, $eps)) {print "ok 14\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 14\n";
}

$c3 = $c2 * -18;
$c3 = $c3 / -18;

if(approx(real_c($c3), 3, $eps) && approx(imag_c($c3), 2, $eps)) {print "ok 15\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 15\n";
}

$c3 = $c2 * -217.125;
$c3 = $c3 / -217.125;

if(approx(real_c($c3), 3, $eps) && approx(imag_c($c3), 2, $eps)) {print "ok 16\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 16\n";
}

##################################
##################################
##################################

$c3 = $c2;

$c2 += $c1;
$c2 -= $c1;

if(approx(real_c($c3), real_c($c2), $eps)) {print "ok 17\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 17\n";
}

$c2 += 17;
$c2 -= 17;

if(approx(real_c($c3), real_c($c2), $eps)) {print "ok 18\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 18\n";
}

$c2 += (-17);
$c2 -= (-17);

if(approx(real_c($c3), real_c($c2), $eps)) {print "ok 19\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 19\n";
}

$c2 += (-19.25);
$c2 -= (-19.25);

if(approx(real_c($c3), real_c($c2), $eps)) {print "ok 20\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 20\n";
}

$c2 *= $c1;
$c2 /= $c1;

if(approx(real_c($c3), real_c($c2), $eps) && approx(imag_c($c3), imag_c($c2), $eps)) {print "ok 21\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 21\n";
}

$c2 *= 17;
$c2 /= 17;

if(approx(real_c($c3), real_c($c2), $eps) && approx(imag_c($c3), imag_c($c2), $eps)) {print "ok 22\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 22\n";
}

$c2 *= -18;
$c2 /= -18;

if(approx(real_c($c3), real_c($c2), $eps) && approx(imag_c($c3), imag_c($c2), $eps)) {print "ok 23\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 23\n";
}

$c2 *= -217.125;
$c2 /= -217.125;

if(approx(real_c($c3), real_c($c2), $eps) && approx(imag_c($c3), imag_c($c2), $eps)) {print "ok 24\n"}
else {
  warn "\$c3: $c3\n";
  print "not ok 24\n";
}

my $c4 = Math::Complex_C::Long->new(7, 12.3);

eval {my $c5 = $c4 + $c1;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 25\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 25\n";
  }
}
else { warn "not ok 25\n"}

eval {my $c5 = $c4 * $c1;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 26\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 26\n";
  }
}
else { warn "not ok 26\n"}

eval {my $c5 = $c4 / $c1;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 27\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 27\n";
  }
}
else { warn "not ok 27\n"}

eval {my $c5 = $c4 - $c1;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 28\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 28\n";
  }
}
else { warn "not ok 28\n"}

eval {my $c5 = $c1 + $c4;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 29\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 29\n";
  }
}
else { warn "not ok 29\n"}

eval {my $c5 = $c1 * $c4;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 30\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 30\n";
  }
}
else { warn "not ok 30\n"}

eval {my $c5 = $c1 / $c4;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 31\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 31\n";
  }
}
else { warn "not ok 31\n"}

eval {my $c5 = $c1 - $c4;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 32\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 32\n";
  }
}
else { warn "not ok 32\n"}

############################
############################

eval {my $c5 = ($c1 == $c4);};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 33\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 33\n";
  }
}
else { warn "not ok 33\n"}

eval {my $c5 = ($c4 == $c1);};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 34\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 34\n";
  }
}
else { warn "not ok 34\n"}

eval {my $c5 = ($c1 != $c4);};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 35\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 35\n";
  }
}
else { warn "not ok 35\n"}

eval {my $c5 = ($c4 != $c1);};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 36\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 36\n";
  }
}
else { warn "not ok 36\n"}

###########################
###########################

eval {$c4 += $c1;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 37\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 37\n";
  }
}
else { warn "not ok 37\n"}

eval {$c4 *= $c1};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 38\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 38\n";
  }
}
else { warn "not ok 38\n"}

eval {$c4 /= $c1;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 39\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 39\n";
  }
}
else { warn "not ok 39\n"}

eval {$c4 -= $c1;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 40\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 40\n";
  }
}
else { warn "not ok 40\n"}

eval {$c1 += $c4;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 41\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 41\n";
  }
}
else { warn "not ok 41\n"}

eval {$c1 *= $c4;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 42\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 42\n";
  }
}
else { warn "not ok 42\n"}

eval {$c1 /= $c4;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 43\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 43\n";
  }
}
else { warn "not ok 43\n"}

eval {$c1 -= $c4;};
if($@) {
  if($@ =~ /Invalid argument supplied/) {print "ok 44\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 44\n";
  }
}
else { warn "not ok 44\n"}

if($c1 == $c1 + 0){print "ok 45\n"}
else {print "not ok 45\n"}

if($c4 == $c4 + 0){print "ok 46\n"}
else {print "not ok 46\n"}

if($c1 != $c1 + 1){print "ok 47\n"}
else {print "not ok 47\n"}

if($c4 != $c4 + 1){print "ok 48\n"}
else {print "not ok 48\n"}

if(Math::Complex_C->new() != Math::Complex_C->new()) {print "ok 49\n"}
else {print "not ok 49\n"}

if(Math::Complex_C::Long->new() != Math::Complex_C::Long->new()) {print "ok 50\n"}
else {print "not ok 50\n"}

if(Math::Complex_C->new(get_nan(), 1) != Math::Complex_C->new(get_nan(), 1)) {print "ok 51\n"}
else {print "not ok 51\n"}

if(Math::Complex_C::Long->new(get_nanl(), 1) != Math::Complex_C::Long->new(get_nanl(), 1)) {print "ok 52\n"}
else {print "not ok 52\n"}

if(Math::Complex_C->new(1, get_nan()) != Math::Complex_C->new(1, get_nan())) {print "ok 53\n"}
else {print "not ok 53\n"}

if(Math::Complex_C::Long->new(1, get_nanl()) != Math::Complex_C::Long->new(1, get_nanl())) {print "ok 54\n"}
else {print "not ok 54\n"}


sub approx {
    if(($_[0] > ($_[1] - $_[2])) && ($_[0] < ($_[1] + $_[2]))) {return 1}
    return 0;
}
