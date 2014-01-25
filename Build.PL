# Build.PL for Perl::Critic::Policy::logicLAB::RequireVersionFormat

# $Id$

use strict;
use Module::Build;

my $build = Module::Build->new(
    dist_author          => 'Jonas B. Nielsen, <jonasbn@cpan.org>',
    module_name          => 'Perl::Critic::Policy::logicLAB::RequireVersionFormat',
	dist_abstract        => 'policy for specifying required version number format',
	dist_abstract        => 'a simple policy enforcing strict version formatting',
    license              => 'artistic',
    recursive_test_files => 0,
    create_makefile_pl   => 'traditional',
    create_readme        => 1,
    requires => {
		'List::MoreUtils'     => '0',
		'Perl::Critic'        => '1.03', #REF: PCPMRVF-15
		'Perl::Critic::Utils' => '0',
		'Test::Perl::Critic'  => '0',
        'perl'                => '5.8.0',
    },
    meta_merge => {
        resources => {
            homepage => 'http://logiclab.jira.com/wiki/display/PCPMRVF/Home',
            bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Critic-Policy-logicLAB-Prohibit-RequireVersionFormat',
            repository => 'https://github.com/jonasbn/pcpmrvf',
            ProjectChangelog =>
                'http://logiclab.jira.com/browse/PCPMRVF#selectedTab=com.atlassian.jira.plugin.system.project%3Achangelog-panel',
            ProjectSite => 'http://logicLAB.jira.com/browse/PCPMRVF',
            ProjectWiki => 'http://logiclab.jira.com/wiki/display/PCPMRVF/Home',
        }
    },
);

$build->create_build_script();

1;
