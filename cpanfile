# Validate with cpanfile-dump
# https://metacpan.org/release/Module-CPANfile
# https://metacpan.org/pod/distribution/Module-CPANfile/lib/cpanfile.pod

requires 'Exporter' => 0;

on 'configure' => sub {
    requires 'ExtUtils::MakeMaker' => '0';
};

on 'test' => sub {
    requires 'Test::More', '0.94';  # So we can run subtests on v5.10
};

# vi:et:sw=4 ts=4 ft=perl
