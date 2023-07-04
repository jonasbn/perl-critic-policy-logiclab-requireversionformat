requires 'Carp';
requires 'Readonly';
requires 'Perl::Critic::Policy';
requires 'Perl::Critic::Utils';
requires 'perl', '5.39.0';
requires 'Data::Dumper';
requires 'List::MoreUtils';

on 'build', sub {
    requires 'Module::Build', '0.4234';
};

on 'test', sub {
    requires 'File::Spec';
    requires 'IO::Handle';
    requires 'IPC::Open3';
    requires 'Pod::Coverage::TrustPod';
    requires 'Test::Fatal';
    requires 'Test::Kwalitee', '1.28';
    requires 'Test::More';
    requires 'Test::Pod', '1.52';
    requires 'Test::Pod::Coverage', '1.10';
};

on 'configure', sub {
    requires 'ExtUtils::MakeMaker';
    requires 'Module::Build', '0.4234';
};

on 'develop', sub {
    requires 'Pod::Coverage::TrustPod';
    requires 'Test::CPAN::Changes', '0.400002';
    requires 'Test::CPAN::Meta::JSON', '0.16';
    requires 'Test::Kwalitee', '1.28';
    requires 'Test::Perl::Critic';
    requires 'Test::Pod', '1.52';
    requires 'Test::Pod::Coverage', '1.10';
};
