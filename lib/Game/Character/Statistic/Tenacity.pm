package Game::Character::Statistic::Tenacity;

use Moo;

use header;

with 'Game::Character::Statistic';

use constant lore_id => 'STT_TEN';

use constant secondary_bonus => 0.015;    # bonus damage / healing
