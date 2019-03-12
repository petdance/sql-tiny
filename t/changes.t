#!/usr/bin/perl

use warnings;
use strict;
use 5.010;

use Test::More;

eval 'use Test::CPAN::Changes';
plan skip_all => 'Test::CPAN::Changes required for this test' if $@;
changes_ok();
