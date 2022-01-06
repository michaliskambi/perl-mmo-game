package Web::Form;

use Form::Tiny -consistent;

use header;

form_hook after_error => sub ($self, $error) {
	if (!($error->error isa 'i18n')) {
		$error->set_error(_t $error->error);
	}
};
