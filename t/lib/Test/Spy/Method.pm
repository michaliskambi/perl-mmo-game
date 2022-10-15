package Test::Spy::Method;

use My::Moose;

use header;

has param 'method_name';

has field 'call_history' => (
	clearer => -hidden,
	lazy => sub { [] },
);

has field '_call_iterator' => (
	writer => 1,
	clearer => 1,
	lazy => sub { 0 },
);

has field '_throws' => (
	writer => 1,
	clearer => 1,
);

has field '_calls' => (
	writer => 1,
	clearer => 1,
);

has field '_returns' => (
	writer => 1,
	clearer => 1,
);

has field '_returns_list' => (
	writer => 1,
	clearer => 1,
);

with qw(Test::Spy::Interface);

sub _increment_call_iterator ($self, $count = 1) {
	my $new = $self->_call_iterator + $count;

	croak 'call stack for ' . $self->method_name . ' exhausted!'
		if $new >= $self->called_times;

	$self->_set_call_iterator($new);

	return;
}

sub called_times ($self)
{
	return scalar $self->call_history->@*;
}

sub called_with ($self)
{
	return $self->call_history->[$self->_call_iterator];
}

sub first_called_with ($self)
{
	$self->_set_call_iterator(0);
	return $self->called_with;
}

sub next_called_with ($self)
{
	$self->_increment_call_iterator;
	return $self->called_with;
}

sub last_called_with ($self)
{
	$self->_set_call_iterator($self->called_times - 1);
	return $self->called_with;
}

sub was_called ($self, $times = undef)
{
	return $self->called_times == $times if $times;
	return $self->called_times > 0;
}

sub was_called_once ($self)
{
	return $self->was_called(1);
}

sub clear ($self)
{
	$self->_clear_call_history;
	$self->_clear_call_iterator;

	return $self;
}

sub _forget ($self)
{
	$self->_clear_returns;
	$self->_clear_returns_list;
	$self->_clear_calls;
	$self->_clear_throws;

	return;
}

sub should_return ($self, @values)
{
	$self->_forget;

	if (@values == 1) {
		$self->_set_returns($values[0]);
	}
	else {
		$self->_set_returns_list([@values]);
	}

	return $self->clear;
}

sub should_call ($self, $sub)
{
	croak 'should_call expects a coderef'
		unless ref $sub eq 'CODE';

	$self->_forget;

	$self->_set_calls($sub);

	return $self->clear;
}

sub should_throw ($self, $exception)
{
	$self->_forget;

	$self->_set_throws($exception);

	return $self->clear;
}

sub _called ($self, $inner_self, @params)
{
	push $self->call_history->@*, [@params];

	die $self->_throws
		if defined $self->_throws;

	return $self->_calls->($inner_self, @params)
		if $self->_calls;

	return $self->_returns_list->@*
		if $self->_returns_list;

	return $self->_returns;
}

