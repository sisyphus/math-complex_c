use ExtUtils::MakeMaker;

$defines = $] < 5.008 ? "-DOLDPERL" : "-DNEWPERL";

my %options = %{
{
  'NAME' => 'Math::Complex_C::Long',
  'LIBS' => [
    '-lm'
  ],
  'DEFINE' => $defines,
  'INC' => '',
  'VERSION_FROM' => 'Long.pm'
}
};
WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }
