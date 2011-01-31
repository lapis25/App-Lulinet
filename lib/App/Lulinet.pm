package App::Lulinet;
use strict;
use warnings;
use utf8;
our $VERSION = '0.01';

use Plack::Request;
use Text::Xslate qw( mark_raw );
use Text::Xatena;
use Text::Xatena::Inline;
use Data::Section::Simple;
use Path::Class;
use Encode qw( encode_utf8 );

#use Data::Dumper;

my $root = dir();

my $vpath = Data::Section::Simple->new()->get_data_section();

my $xatena        = Text::Xatena->new(hatena_compatible => 1);
my $xatena_inline = Text::Xatena::Inline->new;

my $tx = Text::Xslate->new(
    path      => [ $vpath ],
    cache_dir => '/tmp/app-lulinet',
    cache     => 0,
);

sub handler {
    my $env = shift;
    my $req = Plack::Request->new($env);

    my $path_info = $req->env->{PATH_INFO};
    $path_info .= 'index' if $path_info =~ /\/$/;

    my $file = $root
        ->subdir('data')
        ->file( $path_info .'.txt');

    my $contents;
    if(-e $file) {
        my $text = $file->slurp(iomode => '<:utf8');
        $contents = $xatena->format($text, inline => $xatena_inline);
    } else {
        return [404, ['Content-Type' => 'text/html'], ['Not Found']];
    }

    my $vars = {
        title   => 'LAPISLAZULI HILL',
        contents => mark_raw($contents),
    };

    my $body = encode_utf8(
        $tx->render('layout.tx', $vars)
    );

    my $content_type = 'text/html';
    return [
        200,
        [
            'Content-Type'   => $content_type,
            'Content-Length' => length($body),
        ],
        [$body]
    ];

}

1;
__DATA__
@@ layout.tx
<!DOCTYPE HTML>
<html>
<head>
  <meta charset=UTF-8>
   <link rel="shortcut icon" href="/static/images/lapis25-fox-face.jpg">
  <link href='http://fonts.googleapis.com/css?family=Droid+Sans+Mono&subset=latin' rel='stylesheet' type='text/css'>
  <link rel="stylesheet" href="/static/css/styles.css" type="text/css">
  <title><: $title :></title>
</head>
<body>
<h1>LAPISLAZULI HILL</h1> 
<div id="description"> 
  ただ言葉と戯れるのみで主義や主張とは席を同せず<br> 
  その言葉は移ろいゆきて自我や存在とを形に定めず<br> 
</div> 
<div id="contents">
<: $contents :></div>
</body>
</html>

__END__

=head1 NAME

App::Lulinet -

=head1 SYNOPSIS

  use App::Lulinet;

=head1 DESCRIPTION

App::Lulinet is

=head1 AUTHOR

lapis25 E<lt>lapis25@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
