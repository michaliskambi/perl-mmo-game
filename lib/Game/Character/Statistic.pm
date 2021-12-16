package Game::Character::Statistic;

use Moo::Role;

use header;

with 'Game::Lore';

sub _get
{
	state $list =
		{map { $_->lore_id => $_->new } Game::Common->load_classes('Game::Character::Statistic', 'Statistic/*.pm')};
}

