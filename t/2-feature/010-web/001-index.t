use Test::Mojo;

use testheader;

my $t = Test::Mojo->new('Web');
$t->get_ok('/')->status_is(200);

$t->content_like(qr/Login/);

done_testing();