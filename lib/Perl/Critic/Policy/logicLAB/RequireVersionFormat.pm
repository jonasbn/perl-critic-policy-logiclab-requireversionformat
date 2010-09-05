package Perl::Critic::Policy::logicLAB::RequireVersionFormat;

# $Id$

use strict;
use warnings;
use base
    qw(Perl::Critic::Policy::Modules::RequireVersionVar Perl::Critic::Policy);
use Perl::Critic::Utils qw{ $SEVERITY_MEDIUM :booleans };
use List::MoreUtils qw(any);
use Data::Dumper;
use Carp qw(carp);

our $VERSION = '0.01';

## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
Readonly::Scalar my $EXPL =>
    q{"$VERSION" variable should conform with the configured};
Readonly::Scalar my $DESC => q{"$VERSION" variable not conforming};
## critic [ValuesAndExpressions::RequireInterpolationOfMetachars]
use constant supported_parameters => ();
use constant default_severity     => $SEVERITY_MEDIUM;
use constant default_themes       => qw(maintenance);
use constant applies_to           => 'PPI::Document';

my @strip_tokens = qw(
    PPI::Token::Structure
    PPI::Token::Whitespace
);

my @parsable_tokens = qw(
    PPI::Token::Quote::Double
    PPI::Token::Quote::Single
    PPI::Token::Number::Float
    PPI::Token::Number::Version
);

sub violates {
    my ( $self, $elem, $doc ) = @_;

    my $version_spec = q{};
    my $separator;

    if ( my $stmt = $doc->find_first( \&_is_version_declaration_statement ) )
    {

        my $tokenizer = PPI::Tokenizer->new( \$stmt );
        my $tokens    = $tokenizer->all_tokens;

        ( $version_spec, $separator ) = $self->_extract_version($tokens);
    }

    if ( $version_spec and $self->{_strict_quotes} and $separator ) {
        if ( $separator ne q{'} ) {
            return $self->violation( $DESC, $EXPL, $doc );
        }
    }

    if ( $version_spec and $self->{_ignore_quotes} and $separator ) {
        $version_spec =~ s/$separator//xsmg;
    }

    foreach my $format ( @{ $self->{_formats} } ) {
        if ( $version_spec and $version_spec !~ m/$format/xsm ) {
            return $self->violation( $DESC, $EXPL, $doc );
        }
    }

    return;
}

sub initialize_if_enabled {
    my ( $self, $config ) = @_;

    $self->{_strict_quotes} = $config->get('strict_quotes') || 0;
    $self->{_ignore_quotes} = $config->get('ignore_quotes') || 1;
    $self->{_formats}       = $config->get('formats')
        || [qw(\A\d+\.\d+(_\d+)?\z)];

    return $TRUE;
}

sub _extract_version {
    my ( $self, $tokens ) = @_;

    ##stripping whitespace and structure tokens
    my $i = 0;
    foreach my $t ( @{$tokens} ) {
        if ( any { ref $t eq $_ } @strip_tokens ) {
            splice @{$tokens}, $i, 1;
        }
        $i++;
    }

    #Trying to locate and match version containing token
    foreach my $t ( @{$tokens} ) {
        if ( any { ref $t eq $_ } @parsable_tokens ) {
            if ( $t->{separator} ) {
                return ( $t->content, $t->{separator} );
            } else {
                return $t->content;
            }
        }
    }

    return;
}

sub _is_version_declaration_statement {    ## no critic (ArgUnpacking)
    return 1 if _is_our_version(@_);
    return 1 if _is_vars_package_version(@_);
    return 0;
}

sub _is_our_version {
    my ( undef, $elem ) = @_;
    return if not $elem;
    $elem->isa('PPI::Statement::Variable') || return 0;
    $elem->type() eq 'our' || return 0;
    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    return any { $_ eq '$VERSION' } $elem->variables();
}

sub _is_vars_package_version {
    my ( undef, $elem ) = @_;
    return if not $elem;
    $elem->isa('PPI::Statement') || return 0;
    return any {
        $_->isa('PPI::Token::Symbol')
            and $_->content =~ m{ \A \$(\S+::)*VERSION \z }xms;
    }
    $elem->children();
}

1;

__END__

=pod

=head1 NAME

Perl::Critic::Policy::logicLAB::RequireVersionFormat

=head1 AFFILIATION

This policy is part of L<Perl::Critic::logicLAB> distribution.

=head1 VERSION

This documentation describes version 0.01

=head1 DESCRIPTION

    
=head1 CONFIGURATION

This Policy is not configurable except for the standard options.
    
=head1 DEPENDENCIES AND REQUIREMENTS

=over

=item * L<Perl::Critic>

=item * L<Perl::Critic::Utils>

=item * L<Readonly>

=item * L<Test::More>

=item * L<Test::Perl::Critic>

=back

=head1 INCOMPATIBILITIES

This distribution has no known incompatibilities.

=head1 BUGS AND LIMITATIONS

=head1 BUG REPORTING

Please use Requets Tracker for bug reporting:

        http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Critic-logicLAB-Prohibit-RequireVersionFormat

=head1 TEST AND QUALITY

The following policies have been disabled for this distribution

=over

=item * L<Perl::Crititc::Policy::ValuesAndExpressions::ProhibitConstantPragma>

=item * L<Perl::Crititc::Policy::NamingConventions::Capitalization>

=back

=head2 TEST COVERAGE

    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    File                           stmt   bran   cond    sub    pod   time  total
    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    ...s/RequireVersionFormat.pm  100.0   89.3   88.9  100.0  100.0  100.0   97.0
    Total                         100.0   89.3   88.9  100.0  100.0  100.0   97.0
    ---------------------------- ------ ------ ------ ------ ------ ------ ------

=head1 TODO

=over

=item * I would like to integrate the features of this policy into L<Perl::Critic::Policy::Modules::RequireVersionVar>, but I was aiming for a proof of concept first - so this planned patch is still in the pipeline.

=back

=head1 SEE ALSO

=over

=item * L<http://logiclab.jira.com/wiki/display/OPEN/Versioning>

=item * L<version>

=item * L<http://search.cpan.org/dist/Perl-Critic/lib/Perl/Critic/Policy/Modules/RequireVersionVar.pm>

=back

=head1 AUTHOR

=over

=item * Jonas B. Nielsen, jonasbn C<< <jonasbn@cpan.org> >>

=back

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009-2010 Jonas B. Nielsen. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
