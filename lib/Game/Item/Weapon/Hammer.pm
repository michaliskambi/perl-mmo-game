package Game::Item::Weapon::Hammer;

use Moo;
use Game::Ability::Attribute::Physical;
use Game::Config;

use header;

with 'Game::Item::Weapon';

use constant lore_id => 'WEA_HAM';
use constant both_hands => 0;
use constant attribute => Game::Ability::Attribute::Physical->get;
use constant range => Game::Config->meele_range;
use constant damage_deviation => 0.05;
use constant scaling => 'STT_STR:0.9;STT_AGI:0.1';
use constant base_damage_bonus => 0;
