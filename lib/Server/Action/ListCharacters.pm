package Server::Action::ListCharacters;

use My::Moose;
use Resource::CharacterList;
use Model::PlayerSession;

use header;

extends 'Server::Action';

use constant name => 'list_characters';
use constant required_state => Model::PlayerSession->STATE_LOGGED_IN;

sub handle ($self, $session_id, $id, $)
{
	state $repo = DI->get('units');

	my $session = $self->cache->load(PlayerSession => $session_id);
	my $unit = $repo->load_user($session->user_id);

	return $self->send_to(
		$session_id,
		Resource::CharacterList->new($unit),
		id => $id
	);
}
