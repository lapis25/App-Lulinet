#!perl

use strict;
use warnings;
use utf8;
use lib qw( lib extlib );

use Plack::Builder;
use App::Lulinet;

my $app = sub { App::Lulinet::handler($_[0]) };

builder {
    enable "Static",
        path => qr{^/(images|js|css)},
        root => './htdocs/';
    enable "ReverseProxy";
    $app;
};
