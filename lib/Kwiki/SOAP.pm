package Kwiki::SOAP;
use strict;
use warnings;
use Kwiki::Plugin '-Base';
use Kwiki::Installer '-base';

our $VERSION = 0.03;

const class_title => 'generic soap retrieval';
const class_id => 'soapwafl';
const css_file => 'soap.css';

sub register {
    my $registry = shift;
    $registry->add(template => 'base_soap.html');
    $registry->add(wafl => soap => 'Kwiki::SOAP::Wafl');
}

package Kwiki::SOAP::Wafl;
use base 'Spoon::Formatter::WaflPhrase';
use SOAP::Lite;
use YAML;

sub html {
    my ($wsdl, $method, @args) = split(' ', $self->arguments);
    return $self->walf_error
        unless $method;

    $self->use_class('soapwafl');
    my $result = $self->soap($wsdl, $method, \@args);
    print STDERR Dump($result);

    return $self->pretty($result);
}

sub soap {
    my $wsdl = shift;
    my $method = shift;
    my $args_list = shift;

    my $soap = SOAP::Lite->service($wsdl);

    return $soap->$method(@$args_list);
}

sub pretty {
    my $results = shift;

    $self->hub->template->process('base_soap.html',
        soap_class  => $self->soapwafl->class_id,
        soap_output => Dump($results),
    );
}



package Kwiki::SOAP;
1;

__DATA__

=head1 NAME 

Kwiki::SOAP - Base class for accessing SOAP services from a WAFL phrase

=head1 SYNOPSIS

  {soap <wsdl file> <method> [<arg1> <arg2>]}

=head1 DESCRIPTION

Kwiki::SOAP provides a base class and framework for access SOAP services
from a WAFL phrase. It can be used directly (as shown in the synopsis)
but is designed to be subclassed for special data handling and presentation
management.

You can see Kwiki::SOAP in action at http://www.burningchrome.com/wiki/

This is alpha code that needs some feedback and playing to find its
way in life.

=head1 AUTHORS

Chris Dent <cdent@burningchrome.com>

=head1 SEE ALSO

L<Kwiki>
L<SOAP::Lite>
L<Kwiki::SOAP::Fortune>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Chris Dent

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__css/dated_announce.css__
div.soap { background: #dddddd; }
__template/tt2/base_soap.html__
<!-- BEGIN base_soap.html -->
<div class="[% soap_class %]">
<pre>
[% soap_output %]
</pre>
</div>
<!-- END base_soap.html -->
