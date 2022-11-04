package Server::Event::PlayerHasEnteredGame;

use My::Moose;

use header;

extends 'Server::Event::PlayerHasEnteredLocation';

use constant name => 'player_has_entered_game';

sub update_session ($self, $session)
{
	$self->SUPER::update_session($session);
	$session->set_state($session->STATE_PLAYING);

	return;
}

sub update_actor ($self, $actor)
{
	$actor->variables->set_location_id($self->game_process->location_data->location->id);
	$actor->player->set_online(1);
	$self->models->update($actor->player);

	return;
}

# same handle() as in parent

