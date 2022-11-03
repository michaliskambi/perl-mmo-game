package Service::DataBus;

use My::Moose;
use Data::ULID qw(ulid);

use header;

extends 'Service::Channel';

sub broadcast ($self, $name, @args)
{
	$self->SUPER::broadcast(undef, [ulid, $name, @args]);

	return;
}

sub dispatch ($self, $location, $name, @args)
{
	$self->SUPER::broadcast($location, [$name, @args]);

	return;
}

sub emit ($self, $processable, $session, @args)
{
	if ($processable->does('Server::Role::WithGameProcess')) {
		$self->dispatch($session->location, $processable->name, ($session->id, @args));
	}
	else {
		$self->broadcast($processable->name, ($session->id, @args));
	}
}

=pod

This is a communication channel that is specifically used by the worker
(Server::Worker) to communicate with child processes.

