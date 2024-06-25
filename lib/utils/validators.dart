String? validateEmail (String? email)  {
  if (email == null || email.isEmpty) {
    return 'Por favor, introduzca su email.';
  }
  else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9  .!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    return 'Por favor, introduzca un email válido.';
  }
  return null;
}

String? validatePasswordOnLogin (String? password)  {
  if (password == null || password.isEmpty) {
    return 'Por favor, introduzca su contraseña.';
  }
  else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
      .hasMatch(password)) {
    return 'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.';
  }
  return null;
}

String? validatePasswordOnSignUp (String? password, String? otherPassword)  {
  if (password == null || password.isEmpty) {
    return 'Por favor, introduzca su contraseña.';
  }
  else if (password != otherPassword) {
    return 'Las contraseñas no coinciden.';
  }
  else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
      .hasMatch(password)) {
    return 'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.';
  }

  return null;
}

String? validateName (String? name)  {
  if (name == null || name.isEmpty) {
    return 'Por favor, introduzca su nombre.';
  }
  return null;
}

String? validateSurname (String? surname)  {
  if (surname == null || surname.isEmpty) {
    return 'Por favor, introduzca sus apellidos.';
  }
  return null;
}

String? validatePhone (String? phone)  {
  if (phone == null || phone.isEmpty) {
    return 'Por favor, introduzca su teléfono.';
  }
  else if (!RegExp(r'^[0-9]{9}$')
      .hasMatch(phone)) {
    return 'Por favor, introduczca un teléfono válido.';
  }
  return null;
}

String? validateHeight (String? height)  {
  if (height == null || height.isEmpty) {
    return 'Por favor, introduzca su altura en metros.';
  }
  else if (double.tryParse(height) == null) {
    return 'Por favor, introduczca una altura válida';
  }
  return null;
}

String? validateWeight (String? weight)  {
  if (weight == null || weight.isEmpty) {
    return 'Por favor, introduzca su peso en kgs.';
  }
  else if (double.tryParse(weight) == null) {
    return 'Por favor, introduczca un peso válido';
  }
  return null;
}

String? validateBirthday (String? birthday)  {
  if (birthday == null || birthday.isEmpty) {
    return 'Por favor, introduzca su cumpleaños.';
  }
  else if (DateTime.parse(birthday).isAfter(DateTime.now().subtract(const Duration(days: 6574)))) {
    return 'Por favor, introduczca un cumpleaños válido.';
  }
  return null;
}

String? validateMedicalConditions (String? cond)  {
  if (cond == null || cond.isEmpty) {
    return 'Por favor, introduzca sus condiciones médicas previas.';
  }
  return null;
}

String? validateGender (String? gender)  {
  if (gender == '') {
    return 'Por favor, introduzca su género.';
  }
  return null;
}

String? validateOptions (String? options)  {
  if (options == '') {
    return 'Por favor, introduzca su preferencia de notificaciones.';
  }
  return null;
}

String? validateCollege (String? options)  {
  if (options == '') {
    return 'Por favor, introduzca su número de colegio.';
  }
  return null;
}

String? validateText (String? text)  {
  if (text == null || text.isEmpty) {
    return 'Por favor, especificanos tus objetivos.';
  }
  return null;
}

String? validateMotivation (String? value)  {
  if (value == "") {
    return 'Por favor, especificanos tus motivaciones.';
  }
  return null;
}

String? validateNote (String? cond)  {
  if (cond == null || cond.isEmpty) {
    return 'Por favor, introduzca una razón.';
  }
  return null;
}

String? validateDishName (String? cond)  {
  if (cond == null || cond.isEmpty) {
    return 'Por favor, introduzca un nombre para el plato.';
  }
  return null;
}

String? validateInstructions (String? cond)  {
  if (cond == null || cond.isEmpty) {
    return 'Por favor, introduzca sus instrucciones para el plato.';
  }
  return null;
}

String? validateMessageText (String? email)  {
  if (email == null || email.isEmpty) {
    return 'Introduzca un mensaje.';
  }
  return null;
}