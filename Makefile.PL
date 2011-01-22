use inc::Module::Install;
name 'App-Lulinet';
all_from 'lib/App/Lulinet.pm';

# requires '';
requires 'Plack';
requires 'Plack::Middleware::ReverseProxy';
requires 'Text::Xslate';
requires 'Data::Section::Simple';
requires 'Text::Xatena';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
