use lib 't', 'lib';
use strict;
use warnings;
use Test::More tests => 2;
use Kwiki;

BEGIN {
    use_ok 'Kwiki::SOAP::Fortune';
}

SKIP: {
skip "templates make tests hard", 1;
my $content =<<"EOF";
=== Hello

{fortunesoap zippy}

EOF

    my $kwiki = Kwiki->new;
    my $hub = $kwiki->load_hub({plugin_classes => ['Kwiki::SOAP::Fortune']});
    my $registry = $hub->load_class('registry');
    $registry->update();
    $hub->load_registry();
    my $formatter = $hub->load_class('formatter');

    my $output = $formatter->text_to_html($content);
    diag($output);
    like($output, qr/fortune/, 'content looks okay');
}



