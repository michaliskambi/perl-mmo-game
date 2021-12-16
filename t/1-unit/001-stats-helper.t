use testheader;

use Game::Helper::Stats;

is Game::Helper::Stats->from_string('A:5;B:3;AB:3.33333'), {
	A => 5,
	B => 3,
	AB => '3.33333',
	},
	'from_string return value ok';

my $test = {
	test => 8,
	ASD => 3,
};

is Game::Helper::Stats->from_string(Game::Helper::Stats->to_string($test)),
	$test, 'to_string return value ok';

is Game::Helper::Stats->weld_strings(
	'A:1;B:2',
	'B:3;C:4',
	), {
		A => 1,
		B => 3,
		C => 4,
	},
	'weld_strings return value ok';

done_testing;

