use testheader;

use Game::Mechanics::Movement;
use Game::Object::Movement;
use Game::Object::Map;
use Model::CharacterVariables;

# load lore data
use Utils;

my $map = Game::Object::Map->new(map => <<MAP);
OOOOX
OOOOX
OOOOX
MAP

my $variables = Model::CharacterVariables->new(
	location_id => 'dont care',
	pos_x => 0.2,
	pos_y => 0.3,
	health => 1,
	energy => 1,
);

my $movement_full = Game::Object::Movement->new(
	variables => $variables,
	speed => 1,
	time => 0,
	x => 3.8,
	y => 2.9,
);

my $movement_partial = Game::Object::Movement->new(
	variables => $variables,
	speed => 1,
	time => 0,
	x => 4.8,
	y => 4.9,
);

test_data
	'should process movement' => [
		[$movement_full, $movement_full->time],
		[$movement_partial, $movement_partial->time, sub { 2.5 < shift() < 3 }, sub { 2.5 < shift() < 3 }],
	];

before_each sub ($mov, $start, @) {
	$mov->set_time($start);
	$mov->variables->set_pos_x(0.2);
	$mov->variables->set_pos_y(0.3);
};

test should_process_movement => sub ($mov, $start, $x_comp = undef, $y_comp = undef) {
	my $finished = 0;

	note 'eta: ' . $mov->eta;
	while (!$finished) {
		$start += 0.5;
		$finished = !Game::Mechanics::Movement->move($mov, $start, $map);

		last if $start > 10;
	}

	ok $finished, 'finished ok';
	if ($x_comp) {
		ok $x_comp->($variables->pos_x), 'pos x ok';
	}
	else {
		is $variables->pos_x, $mov->x, 'pos x ok';
	}

	if ($y_comp) {
		ok $y_comp->($variables->pos_y), 'pos y ok';
	}
	else {
		is $variables->pos_y, $mov->y, 'pos y ok';
	}
};

done_testing;

