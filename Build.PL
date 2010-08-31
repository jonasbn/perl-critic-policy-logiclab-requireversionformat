# Build.PL for Perl::Critic::JONASBN

# $Id$

use strict;
use Module::Build;

my $build = Module::Build->new(
    dist_author          => 'Jonas B. Nielsen, <jonasbn@cpan.org>',
    module_name          => 'Perl::Critic::Policy::Modules::RequireVersionFormat',
	dist_abstract        => 'a simple policy enforcing strict version formatting',
    license              => 'artistic',
    recursive_test_files => 0,
    create_makefile_pl   => 'traditional',
    create_readme        => 1,
    requires => {
        'Data::Dumper' => '0', #Debugging
    },
    meta_merge => {
        resources => {
            homepage => 'http://logiclab.jira.com/wiki/display/PCPMRVF/Home',
            repository => 'http://logicLAB.jira.com/svn/PCPMRVF',
			ProjectSite => 'http://logicLAB.jira.com/browse/PCPMRVF',
        }
    },
);

$build->create_build_script();

1;
