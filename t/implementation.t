
# $Id$

use strict;
use  warnings;

use Test::More tests => 4;

use_ok('Perl::Critic::Policy::Modules::RequireVersionFormat');

ok(my $policy = Perl::Critic::Policy::Modules::RequireVersionFormat->new());

isa_ok($policy, 'Perl::Critic::Policy::Modules::RequireVersionFormat');

can_ok($policy, qw(violates _is_version_declaration _is_our_version _is_vars_version _is_package_version _is_readonly_version));
