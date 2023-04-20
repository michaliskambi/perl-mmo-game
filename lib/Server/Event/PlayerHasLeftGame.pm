package Server::Event::PlayerHasLeftGame;

use My::Moose;
use Resource::LocationData;

use header;

extends 'Server::Event';

has injected 'units_repo';

use constant name => 'player_has_left_game';

sub handle ($self, $player_id, $)
{
	my $actor = $self->server->get_player($player_id);

	# TODO: only log out immediately if the player has no combat?
	$actor->player->set_offline;
	$self->models_repo->update($actor->player);
	$self->units_repo->update($actor);

	$self->server->player_left($actor);
	$self->server->log->debug("Logged out player $player_id");
	return;
}

