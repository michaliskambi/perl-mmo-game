package Server::Role::Processable;

use My::Moose::Role;

use header;

has injected 'models_repo';
has injected 'cache_repo';
has injected 'channel' => as => 'channel_service';
has injected 'data_bus';

sub name { ... }
sub handle { ... }
use constant disabled => 0;

sub send_to ($self, $session_id, $echo, %more)
{
	my $data = {
		%more,
		(
			defined $echo
			? (echo => ($echo isa 'Resource' ? $echo->serialize : $echo))
			: ()
		)
	};

	$self->channel->broadcast($session_id, $data);
	return;
}

