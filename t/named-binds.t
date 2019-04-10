#!/usr/bin/perl

use warnings;
use strict;
use 5.010;

use Test::More tests => 1;

use SQL::Tiny ':all';

my @args = (
    'users',
    {
        lockdate => undef,
        qty      => \[ 'TRUNC(?)', 19.85 ],
        status   => 'X',
    },
    {
        orderdate => \'SYSDATE()',
        qty       => \[ 'ROUND(?)', 14.5 ],
        status    => [ 'A', 'B', 'C' ],
    },
);

my @expected_positional = (
    'UPDATE users SET lockdate=NULL, qty=TRUNC(?), status=? WHERE orderdate=SYSDATE() AND qty=ROUND(?) AND status IN (?,?,?)',
    [ 19.85, 'X', 14.5, 'A', 'B', 'C' ],
);

my @expected_named = (
    'UPDATE users SET lockdate=NULL, qty=TRUNC(:qty), status=:status WHERE orderdate=SYSDATE() AND qty=ROUND(:qty2) AND status IN (:status1,:status2,:status3)',
    {
        ':qty'     => 19.85,
        ':status'  => 'X',
        ':qty2'    => 14.5,
        ':status1' => 'A',
        ':status2' => 'B',
        ':status3' => 'C',
    }
);

check_call(
    \&sql_update,
    \@args,
    \@expected_positional,
    \@expected_named,
    'Simple'
);

done_testing();

exit 0;


sub check_call {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $func                = shift;
    my $args                = shift;
    my $expected_positional = shift;
    my $expected_named      = shift;
    my $msg                 = shift;

    return subtest "check_call( $msg )" => sub {
        plan tests => 2;

        my ($sql,$binds) = $func->( @{$args} );

        is( $sql, $expected_positional->[0], 'Positional SQL matches' );
        is_deeply( $binds, $expected_positional->[1], 'Positional binds match' );

        local $SQL::Tiny::NAMED_BINDS = 1;
    };
}
