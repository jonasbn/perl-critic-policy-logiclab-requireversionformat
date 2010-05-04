package Perl::Critic::Policy::Modules::RequireVersionFormat;

# $Id$

use strict;
use warnings;
use base
    qw(Perl::Critic::Policy::Modules::RequireVersionVar Perl::Critic::Policy);
use Perl::Critic::Utils qw{ $SEVERITY_MEDIUM };
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
my $ignore_quotes = 1;
my $format        = '\A\d+\.\d+(_\d+)?\z';

#-----------------------------------------------------------------------------

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

    if ( $version_spec and $ignore_quotes and $separator ) {
        $version_spec =~ s/$separator//xsmg;
    }

    if ( $version_spec and $version_spec !~ m/$format/xsm ) {
        return $self->violation( $DESC, $EXPL, $doc );
    }

    return;
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

Perl::Critic::Policy::Modules::RequireVersionFormat

=head1 SYNOPSIS

=head1 VERSION

This documentation describes version 0.01

=head1 DESCRIPTION

=head1 AFFILIATION

This policy is part of L<Perl::Critic::JONASBN> distribution.
    
=head1 CONFIGURATION

This Policy is not configurable except for the standard options.
    
=head1 DEPENDENCIES AND REQUIREMENTS

Please see the specific policies.

=head1 INCOMPATIBILITIES

No known incompatibilities.

=head1 BUGS AND LIMITATIONS

=head1 BUG REPORTING

=head1 TEST AND QUALITY

=head2 TEST COVERAGE

    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    File                           stmt   bran   cond    sub    pod   time  total
    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    ...s/RequireVersionFormat.pm  100.0   89.3   88.9  100.0  100.0  100.0   97.0
    Total                         100.0   89.3   88.9  100.0  100.0  100.0   97.0
    ---------------------------- ------ ------ ------ ------ ------ ------ ------

=head1 TODO

=head1 SEE ALSO

=over

=item * L<Perl::Critic>

=item * L<>

=back

=head1 AUTHOR

=over

=item * Jonas B. Nielsen, jonasbn C<< <jonasbn@cpan.org> >>

=back

=head1 COPYRIGHT

=head1 LICENSE

=cut
