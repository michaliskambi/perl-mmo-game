use v5.32;
use warnings;

use Test::More;
use Test::Exception;
use Game::Ability;
use Game::Common::Container;
use Game::Model::User;
use Game::Character::Statistic;
use lib 't/lib';
use DatabaseTest;

use utf8;

DatabaseTest->test(
	sub {
		### uses Game::Repository::LoreData
		my $class = Game::Character::Statistic->get('STT_STR');
		is $class->lore_name, 'Siła', 'lore name ok';

		### test Game::Repository::CharCache
		my $char_repo = resolve('repo')->char_cache;
		ok $char_repo, 'character cache repo resolve ok';

		my $data = {
			level => 5,
			health_max => 300,
			health_regen => 1.5,
			mana_max => 150,
			mana_regen => 6,
			stats => 'STT_STR:30;STT_AGI:19;STT_INT:10;STT_STA:25',
		};

		my $model = Game::Model::Character->dummy->new();
		$char_repo->save($model->id, $data);

		my $loaded = $char_repo->load($model->id);
		is_deeply $loaded, $data, 'char cache repo save-load ok';

		$data->{health_max} += 5;
		ok $char_repo->save($model->id, $data), 'update ok';

		### test Game::Repository::Schema
		my $user = Game::Model::User->dummy->new(
			email => 'brtastic.dev@gmail.com',
		);

		$user->set_password('test');
		my $schema_repo = resolve('repo')->schema;
		ok $schema_repo, 'schema repo resolve ok';

		dies_ok { $schema_repo->save($user) } 'dummies cannot be saved';

		$user->promote;
		lives_ok { $schema_repo->save($user) } 'non-dummies can be saved';

		my $fetched = $schema_repo->load(User => $user->id);
		is_deeply $fetched->serialize, $user->serialize, 'after save ok';

		$user->set_password('test2');
		lives_ok { $schema_repo->save($user, 1) } 'update ok';
		$fetched = $schema_repo->load(User => $user->id);
		is_deeply $fetched->serialize, $user->serialize, 'after update ok';
	}
);

done_testing;
