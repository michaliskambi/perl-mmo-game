package Server::Command::ListCharacters;

use My::Moose;
use DI;
use Resource::CharacterList;
use Model::PlayerSession;

use header;

extends 'Server::Command';

sub name { 'list_characters' }
sub required_state { Model::PlayerSession->STATE_LOGGED_IN }

sub handle ($self, $session_id, $id, $data)
{
	state $repo = DI->get('units');

	my $session = $self->cache->load(PlayerSession => $session_id);
	my $unit = $repo->get_user($session->user_id);

	return $self->send_to(
		$session_id,
		Resource::CharacterList->new($unit),
		id => $id
	);
};

