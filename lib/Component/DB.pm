package Component::DB;

use My::Moose;
use Mojo::Pg;
use Schema;

use header;

with 'Component::Role::HasEnv';

has 'dbh' => (
	is => 'ro',
	isa => Types::InstanceOf ['Mojo::Pg'],
	lazy => 1,
	default => sub ($self) {
		return Mojo::Pg->new($self->env->getenv('DB_CONNECTION'))
			->username($self->env->getenv('DB_USER'))
			->password($self->env->getenv('DB_PASS'));
	},
);

has 'dbc' => (
	is => 'ro',
	isa => Types::InstanceOf ['Schema'],
	lazy => 1,
	default => sub ($self) {
		return Schema->connect(sub { $self->db->dbh });
	},
);

sub db ($self)
{
	return $self->dbh->db;
}

sub transaction ($self, $code)
{
	return $self->dbc->txn_do($code);
}

