#!/usr/bin/perl

use warnings;
use strict;
use 5.010;

use Benchmark ':all';

use blib;

use SQL::Tiny ':all';

my $fields = {
    name    => 'Dave',
    bingo   => 'bongo',
    updated => \'sysdate',
    empty   => undef,
};

my $where = {
    state   => 'IL',
    status  => [qw( A B C )],
    width   => [ 5, 6 ],
    updated => \'sysdate',
    thingy  => undef,
};


my $sub = sub { my ($sql,$binds) = sql_insert( 'foo', $fields, $where ) };
timethis( 500_000, $sub );

__END__
my $t = timeit( 1000, $sub );
{use Data::Dumper; local $Data::Dumper::Sortkeys=1; warn Dumper( $t )}

