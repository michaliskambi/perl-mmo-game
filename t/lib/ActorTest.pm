package ActorTest;

use Unit::Actor;
use Model::Character;
use Model::CharacterVariables;
use Model::Player;
use Model::User;
use Game::Helpers;
use Game::Config;

use header;

sub save_actor ($self, @params)
{
	my ($actor, %related_models) = $self->create_actor(@params);

	foreach my $model (@related_models{qw(user player character)}) {
		DI->get('models')->save($model);
	}

	# insert, not update
	DI->get('units')->save($actor, 0);

	return ($actor, %related_models);
}

sub create_actor ($self, $password = 'asdfasdf')
{
	my $user = Model::User->dummy(
		email => 'test@test.pl',
	);
	$user->set_password($password);
	$user->promote;

	my $player = Model::Player->new(
		user_id => $user->id,
	);

	my $character = Model::Character->new(
		player_id => $player->id,
		class_id => lore_class('Witchhunter')->id,
		name => 'Whx',
		base_stats => '',
	);

	my $variables = Model::CharacterVariables->new(
		id => $character->id,
		experience => 1234,
		location_id => Game::Config->config->{starting_location}->id,
		pos_x => 2.2,
		pos_y => 5.3,
		health => 100.3,
		energy => 120.6,
	);

	return (
		Unit::Actor->new(
			player => $player,
			character => $character,
			variables => $variables,
		),
		user => $user,
		player => $player,
		character => $character,
		variables => $variables,
	);
}

