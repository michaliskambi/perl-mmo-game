package Game::Character::Statistic::Initiative;

use Moo;

use header;

with 'Game::Character::Statistic';

use constant lore_id => 'STT_INI';

use constant secondary_bonus => 0.02;    # turn frequency
