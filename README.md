[![CPAN version](https://badge.fury.io/pl/Perl-Critic-Policy-logicLAB-RequireVersionFormat.svg)](http://badge.fury.io/pl/Perl-Critic-Policy-logicLAB-RequireVersionFormat)
[![Build Status](https://travis-ci.org/jonasbn/pcpmrvf.svg?branch=master)](https://travis-ci.org/jonasbn/pcpmrvf)
[![Coverage Status](https://coveralls.io/repos/jonasbn/pcpmrvf/badge.png)](https://coveralls.io/r/jonasbn/pcpmrvf)

# NAME

Perl::Critic::Policy::logicLAB::RequireVersionFormat - assert version number formats

# AFFILIATION

This policy is part of [Perl::Critic::logicLAB](https://metacpan.org/pod/Perl%3A%3ACritic%3A%3AlogicLAB) distribution.

# VERSION

This documentation describes version 0.05

# DESCRIPTION

This policy asserts that a specified version number conforms to a specified
format.

The default format is the de facto format used on CPAN. X.X and X.X\_X where X
is an arbitrary integer, in the code this is expressed using the following
regular expression:

    \A\d+\.\d+(_\d+)?\z

The following example lines would adhere to this format:

- 0.01, a regular release
- 0.01\_1, a developer release

Scope, quoting and representation does not matter. If the version specification
is lazy please see ["EXCEPTIONS"](#exceptions).

The following example lines would not adhere to this format and would result in
a violation.

- our ($VERSION) = '$Revision$' =~ m{ \\$Revision: \\s+ (\\S+) }x;
- $VERSION = '0.0.1';
- $MyPackage::VERSION = 1.0.61;
- use version; our $VERSION = qv(1.0.611);
- $VERSION = "0.01a";

In addition to the above examples, there are variations in quoting etc. all
would cause a violation.

## EXCEPTIONS

In addition there are some special cases, were we simply ignore the version,
since we cannot assert it in a reasonable manner.

- our $VERSION = $Other::VERSION;

    We hope that $Other::VERSION conforms where defined, so we ignore for now.

# CONFIGURATION AND ENVIRONMENT

## strict\_quotes

Strict quotes is off by default.

Strict quotes enforces that you version number must be quoted, like so:
'0.01' and "0.01". 0.01 would in this case cause a violation. This
would also go for any additional formats you could configure as valid using
the ["formats"](#formats) parameter below.

    [logicLAB::RequireVersionFormat]
    strict_quotes = 1

## ignore\_quotes

Ignore quotes is on by default.

0.01, '0.01' and "0.01" would be interpreted as the same.

Disabling ignore quotes, would mean that: '0.01' and "0.01" would violate the
default format since quotes are not specified as part of the pattern. This
would also go for any additional formats you could configure as valid using
the ["formats"](#formats) parameter below.

    [logicLAB::RequireVersionFormat]
    ignore_quotes = 0

## formats

If no formats are specified, the policy only enforces the default format
mentioned in ["DESCRIPTION"](#description) in combination with the above two configuration
parameters of course.

    [logicLAB::RequireVersionFormat]
    formats = \A\d+\.\d+(_\d+)?\z || \Av\d+\.\d+\.\d+\z

# DEPENDENCIES AND REQUIREMENTS

- [Perl::Critic](https://metacpan.org/pod/Perl%3A%3ACritic)
- [Perl::Critic::Utils](https://metacpan.org/pod/Perl%3A%3ACritic%3A%3AUtils)
- [Readonly](https://metacpan.org/pod/Readonly)
- [Test::More](https://metacpan.org/pod/Test%3A%3AMore)
- [Test::Perl::Critic](https://metacpan.org/pod/Test%3A%3APerl%3A%3ACritic)

# INCOMPATIBILITIES

This distribution has no known incompatibilities.

# BUGS AND LIMITATIONS

I think it would be a good idea to ignore this particular version string and versions thereof:

    our ($VERSION) = '$Revision$' =~ m{ \$Revision: \s+ (\S+) }x;

I am however still undecided.

# BUG REPORTING

Please use Request Tracker for bug reporting:

        http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Critic-logicLAB-Prohibit-RequireVersionFormat

# TEST AND QUALITY

The following policies have been disabled for this distribution

- [Perl::Crititc::Policy::ValuesAndExpressions::ProhibitConstantPragma](https://metacpan.org/pod/Perl%3A%3ACrititc%3A%3APolicy%3A%3AValuesAndExpressions%3A%3AProhibitConstantPragma)
- [Perl::Crititc::Policy::NamingConventions::Capitalization](https://metacpan.org/pod/Perl%3A%3ACrititc%3A%3APolicy%3A%3ANamingConventions%3A%3ACapitalization)

## TEST COVERAGE

    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    File                           stmt   bran   cond    sub    pod   time  total
    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    ...B/RequireVersionFormat.pm   97.9   75.0   68.2  100.0  100.0  100.0   89.8
    Total                          97.9   75.0   68.2  100.0  100.0  100.0   89.8
    ---------------------------- ------ ------ ------ ------ ------ ------ ------

# TODO

- I would like to integrate the features of this policy into [Perl::Critic::Policy::Modules::RequireVersionVar](https://metacpan.org/pod/Perl%3A%3ACritic%3A%3APolicy%3A%3AModules%3A%3ARequireVersionVar), but I was aiming for a proof of concept first - so this planned patch is still in the pipeline.
- Address the limitation listed in ["BUGS AND LIMITATIONS"](#bugs-and-limitations).

# SEE ALSO

- [http://logiclab.jira.com/wiki/display/OPEN/Versioning](http://logiclab.jira.com/wiki/display/OPEN/Versioning)
- [version](https://metacpan.org/pod/version)
- [http://search.cpan.org/dist/Perl-Critic/lib/Perl/Critic/Policy/Modules/RequireVersionVar.pm](http://search.cpan.org/dist/Perl-Critic/lib/Perl/Critic/Policy/Modules/RequireVersionVar.pm)

# AUTHOR

- Jonas B. (jonasbn) `<jonasbn@cpan.org>`

# LICENSE AND COPYRIGHT

Copyright (c) 2009-2019 Jonas B. (jonasbn) All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
