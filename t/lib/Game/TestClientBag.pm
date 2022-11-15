package Game::TestClientBag;

use My::Moose;
use Mojo::IOLoop;
use Game::TestClient;
use Test2::API qw(context);

use header;

has field 'clients' => (
	isa => Types::ArrayRef [Types::InstanceOf ['Game::TestClient']],
	default => sub { [] },
	'handles[]' => {
		'add_client' => 'push',
	}
);

sub run ($self, $loop = Mojo::IOLoop->singleton)
{
	my @clients = $self->clients->@*;
	$_->run for @clients;

	$loop->recurring(
		1 => sub {
			if (!@clients) {
				$loop->stop;
			}
			else {
				my @finished = grep { $_->finished } @clients;
				if (@finished) {
					my $ctx = context;
					for my $tester (@finished) {
						$ctx->ok($tester->success, 'tester finished normally');
					}
					$ctx->release;

					@clients = grep { !$_->finished } @clients;
				}
			}
		}
	);

	$loop->start unless $loop->is_running;
	return;
}

