#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 5;
use ExtUtils::Typemap;

# typemap only
SCOPE: {
  my $map = ExtUtils::Typemap->new();
  $map->add_typemap(ctype => 'unsigned int', xstype => 'T_IV');
  is($map->as_string(), <<'HERE', "Simple typemap matches expectations");
TYPEMAP
unsigned int	T_IV
HERE
}

# typemap & input
SCOPE: {
  my $map = ExtUtils::Typemap->new();
  $map->add_typemap(ctype => 'unsigned int', xstype => 'T_UV');
  $map->add_inputmap(xstype => 'T_UV', code => '$var = ($type)SvUV($arg);');
  is($map->as_string(), <<'HERE', "Simple typemap (with input) matches expectations");
TYPEMAP
unsigned int	T_UV

INPUT
T_UV
	$var = ($type)SvUV($arg);
HERE
}


# typemap & output
SCOPE: {
  my $map = ExtUtils::Typemap->new();
  $map->add_typemap(ctype => 'unsigned int', xstype => 'T_UV');
  $map->add_outputmap(xstype => 'T_UV', code => 'sv_setuv($arg, (UV)$var);');
  is($map->as_string(), <<'HERE', "Simple typemap (with output) matches expectations");
TYPEMAP
unsigned int	T_UV

OUTPUT
T_UV
	sv_setuv($arg, (UV)$var);
HERE
}

# typemap & input & output
SCOPE: {
  my $map = ExtUtils::Typemap->new();
  $map->add_typemap(ctype => 'unsigned int', xstype => 'T_UV');
  $map->add_inputmap(xstype => 'T_UV', code => '$var = ($type)SvUV($arg);');
  $map->add_outputmap(xstype => 'T_UV', code => 'sv_setuv($arg, (UV)$var);');
  is($map->as_string(), <<'HERE', "Simple typemap (with in- & output) matches expectations");
TYPEMAP
unsigned int	T_UV

INPUT
T_UV
	$var = ($type)SvUV($arg);

OUTPUT
T_UV
	sv_setuv($arg, (UV)$var);
HERE
}

# two typemaps & input & output
SCOPE: {
  my $map = ExtUtils::Typemap->new();
  $map->add_typemap(ctype => 'unsigned int', xstype => 'T_UV');
  $map->add_inputmap(xstype => 'T_UV', code => '$var = ($type)SvUV($arg);');
  $map->add_outputmap(xstype => 'T_UV', code => 'sv_setuv($arg, (UV)$var);');

  $map->add_typemap(ctype => 'int', xstype => 'T_IV');
  $map->add_inputmap(xstype => 'T_IV', code => '$var = ($type)SvIV($arg);');
  $map->add_outputmap(xstype => 'T_IV', code => 'sv_setiv($arg, (IV)$var);');
  is($map->as_string(), <<'HERE', "Simple typemap (with in- & output) matches expectations");
TYPEMAP
unsigned int	T_UV
int	T_IV

INPUT
T_UV
	$var = ($type)SvUV($arg);
T_IV
	$var = ($type)SvIV($arg);

OUTPUT
T_UV
	sv_setuv($arg, (UV)$var);
T_IV
	sv_setiv($arg, (IV)$var);
HERE
}
