import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/utils/validators.dart';

void main()  {

  group('Test User Validators', ()   {

    test('User Email Validator', () {
      String email1 = '';
      String email2 = 'a';
      String email3 = 'a@a';
      String email4 = 'a@a@a';
      String email5 = 'a@a.a';

      expect(validateEmail(email1), 'Por favor, introduzca su email.');
      expect(validateEmail(email2), 'Por favor, introduzca un email válido.');
      expect(validateEmail(email3), 'Por favor, introduzca un email válido.');
      expect(validateEmail(email4), 'Por favor, introduzca un email válido.');
      expect(validateEmail(email5), null);

      String email6 = 'a!@a.a';
      String email7 = 'a!@a!.a';
      String email8 = 'a!@a.a!';
      String email9 = 'a@GMAIL.a';
      String email10 = 'a@a.COM';
      String email11 = 'A@a.a';

      expect(validateEmail(email6), null);
      expect(validateEmail(email7), 'Por favor, introduzca un email válido.');
      expect(validateEmail(email8), null);
      expect(validateEmail(email9), null);
      expect(validateEmail(email10), null);
      expect(validateEmail(email11), null);

      String email12 = 'a9@a.a';
      String email13 = 'a9@a9.a';
      String email14 = 'a9@a.a9';

      expect(validateEmail(email12), null);
      expect(validateEmail(email13), null);
      expect(validateEmail(email14), null);

      String email15 = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaa@a.a';
      String email16 = 'a@aaaaaaaaaaaaaaaaaaaaaaaaaa.a';
      String email17 = 'a@a.aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

      expect(validateEmail(email15), null);
      expect(validateEmail(email16), null);
      expect(validateEmail(email17), null);

    });

    test('User Password Validator', () {
      String pass1 = '';

      expect(validatePasswordOnLogin(pass1),'Por favor, introduzca su contraseña.');

      String pass2 = 'a';
      String pass3 = 'a2';
      String pass4 = 'a2!';
      String pass5 = 'a2!A';
      String pass6 = 'a2!Ababa';
      String pass7 = 'a2! Ababa';
      String pass8 = "a2!'Ababa";
      String pass9 = "ABaa2!'_Ababa";

      expect(validatePasswordOnLogin(pass2),'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.');
      expect(validatePasswordOnLogin(pass3),'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.');
      expect(validatePasswordOnLogin(pass4),'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.');
      expect(validatePasswordOnLogin(pass5),'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.');
      expect(validatePasswordOnLogin(pass6), null);
      expect(validatePasswordOnLogin(pass7), null);
      expect(validatePasswordOnLogin(pass8), null);
      expect(validatePasswordOnLogin(pass9), null);

    });

    test('User Password Validator on Sign up', () {
      String pass1 = '';

      expect(validatePasswordOnLogin(pass1),'Por favor, introduzca su contraseña.');

      String pass2 = 'a';
      String pass3 = 'a2';
      String pass4 = 'a2!';
      String pass5 = 'a2!A';
      String pass6 = 'a2!Ababa';
      String pass7 = 'a2! Ababa';
      String pass8 = "a2!'Ababa";
      String pass9 = "ABaa2!'_Ababa";

      String passOther = 'aa';

      expect(validatePasswordOnSignUp(pass2, pass2),'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.');
      expect(validatePasswordOnSignUp(pass3, pass3),'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.');
      expect(validatePasswordOnSignUp(pass4, pass4),'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.');
      expect(validatePasswordOnSignUp(pass5, pass5),'Debe contener mayúsculas, minúsculas, números, carácteres especiales y contener 8 caracteres.');
      expect(validatePasswordOnSignUp(pass6, pass6), null);
      expect(validatePasswordOnSignUp(pass7, pass7), null);
      expect(validatePasswordOnSignUp(pass8, pass8), null);
      expect(validatePasswordOnSignUp(pass9, pass9), null);

      expect(validatePasswordOnSignUp(pass2, passOther),'Las contraseñas no coinciden.');
      expect(validatePasswordOnSignUp(pass3, passOther),'Las contraseñas no coinciden.');
      expect(validatePasswordOnSignUp(pass4, passOther),'Las contraseñas no coinciden.');
      expect(validatePasswordOnSignUp(pass5, passOther),'Las contraseñas no coinciden.');
      expect(validatePasswordOnSignUp(pass6, passOther), 'Las contraseñas no coinciden.');
      expect(validatePasswordOnSignUp(pass7, passOther), 'Las contraseñas no coinciden.');
      expect(validatePasswordOnSignUp(pass8, passOther), 'Las contraseñas no coinciden.');
      expect(validatePasswordOnSignUp(pass9, passOther), 'Las contraseñas no coinciden.');

    });

    test('User Name Validator on Sign up', () {
      String string1 = '';

      expect(validateName(string1),'Por favor, introduzca su nombre.');


      String string2 = 'a';
      String string3 = 'a2';
      String string4 = 'a2';
      String string5 = 'Félix';
      String string6 = '123John';
      String string7 = "L'garde";
      String string8 = "John III";
      String string9 = "John 3rd";
      String string10 = "****";


      expect(validateName(string2), null);
      expect(validateName(string3), null);
      expect(validateName(string4), null);
      expect(validateName(string5), null);
      expect(validateName(string6), null);
      expect(validateName(string7), null);
      expect(validateName(string8), null);
      expect(validateName(string9), null);
      expect(validateName(string10), null);

    });

    test('User Surname Validator on Sign up', () {
      String string1 = '';

      expect(validateSurname(string1),'Por favor, introduzca sus apellidos.');


      String string2 = 'a';
      String string3 = 'a2';
      String string4 = 'a2';
      String string5 = 'Félix';
      String string6 = '123John';
      String string7 = "L'garde";
      String string8 = "John III";
      String string9 = "John 3rd";
      String string10 = "****";


      expect(validateSurname(string2), null);
      expect(validateSurname(string3), null);
      expect(validateSurname(string4), null);
      expect(validateSurname(string5), null);
      expect(validateSurname(string6), null);
      expect(validateSurname(string7), null);
      expect(validateSurname(string8), null);
      expect(validateSurname(string9), null);
      expect(validateSurname(string10), null);

    });

    test('User Phone Validator on Sign up', () {
      String string1 = '';

      expect(validatePhone(string1),'Por favor, introduzca su teléfono.');


      String string2 = 'a';
      String string3 = 'a2';
      String string4 = 'a2';
      String string5 = 'Félix';
      String string6 = '123John';
      String string7 = "L'garde";
      String string8 = "John III";
      String string9 = "John 3rd";
      String string10 = "****";

      String string11 = '999999';
      String string12 = '999999999999';
      String string13 = '999999999';
      String string14 = '99-999999999';

      expect(validatePhone(string2), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string3), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string4), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string5), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string6), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string7), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string8), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string9), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string10), 'Por favor, introduczca un teléfono válido.');

      expect(validatePhone(string11), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string12), 'Por favor, introduczca un teléfono válido.');
      expect(validatePhone(string13), null);
      expect(validatePhone(string14), 'Por favor, introduczca un teléfono válido.');

    });

    test('User Weight Validator', () {
      String string1 = '';

      expect(validateWeight(string1),'Por favor, introduzca su peso en kgs.');


      String string2 = 'a';
      String string3 = 'a2';
      String string4 = 'a2';
      String string5 = 'Félix';
      String string6 = '123John';
      String string7 = "L'garde";
      String string8 = "John III";
      String string9 = "John 3rd";
      String string10 = "****";

      String string11 = '999999';
      String string12 = '99.9999999999';
      String string13 = '99,9999999';
      String string14 = '99-999999999';

      expect(validateWeight(string2), 'Por favor, introduczca un peso válido');
      expect(validateWeight(string3),'Por favor, introduczca un peso válido');
      expect(validateWeight(string4),'Por favor, introduczca un peso válido');
      expect(validateWeight(string5), 'Por favor, introduczca un peso válido');
      expect(validateWeight(string6), 'Por favor, introduczca un peso válido');
      expect(validateWeight(string7), 'Por favor, introduczca un peso válido');
      expect(validateWeight(string8), 'Por favor, introduczca un peso válido');
      expect(validateWeight(string9), 'Por favor, introduczca un peso válido');
      expect(validateWeight(string10), 'Por favor, introduczca un peso válido');

      expect(validateWeight(string11), null);
      expect(validateWeight(string12), null);
      expect(validateWeight(string13), 'Por favor, introduczca un peso válido');
      expect(validateWeight(string14), 'Por favor, introduczca un peso válido');

    });

    test('User Height Validator', () {
      String string1 = '';

      expect(validateHeight(string1),'Por favor, introduzca su altura en metros.');


      String string2 = 'a';
      String string3 = 'a2';
      String string4 = 'a2';
      String string5 = 'Félix';
      String string6 = '123John';
      String string7 = "L'garde";
      String string8 = "John III";
      String string9 = "John 3rd";
      String string10 = "****";

      String string11 = '999999';
      String string12 = '99.9999999999';
      String string13 = '99,9999999';
      String string14 = '99-999999999';

      expect(validateHeight(string2), 'Por favor, introduczca una altura válida');
      expect(validateHeight(string3),'Por favor, introduczca una altura válida');
      expect(validateHeight(string4),'Por favor, introduczca una altura válida');
      expect(validateHeight(string5), 'Por favor, introduczca una altura válida');
      expect(validateHeight(string6), 'Por favor, introduczca una altura válida');
      expect(validateHeight(string7), 'Por favor, introduczca una altura válida');
      expect(validateHeight(string8), 'Por favor, introduczca una altura válida');
      expect(validateHeight(string9), 'Por favor, introduczca una altura válida');
      expect(validateHeight(string10), 'Por favor, introduczca una altura válida');

      expect(validateHeight(string11), null);
      expect(validateHeight(string12), null);
      expect(validateHeight(string13), 'Por favor, introduczca una altura válida');
      expect(validateHeight(string14), 'Por favor, introduczca una altura válida');

    });

    test('User Birthday Validator', () {
      String string1 = '';

      expect(validateBirthday(string1),'Por favor, introduzca su cumpleaños.');

      String dateOld = '1990-12-01';
      String dateNew = '2010-12-01';

      expect(validateBirthday(dateOld), null);
      expect(validateBirthday(dateNew),'Por favor, introduczca un cumpleaños válido.');

    });

    test('User MedicalCondition Validator', () {
      String string1 = '';

      expect(validateMedicalConditions(string1),'Por favor, introduzca sus condiciones médicas previas.');

      String dateOld = 'Sano';
      String dateNew = 'Sanísimo';

      expect(validateMedicalConditions(dateOld), null);
      expect(validateMedicalConditions(dateNew), null);

    });

    test('User gender Validator', () {
      String string1 = '';

      expect(validateGender(string1),'Por favor, introduzca su género.');

      String dateOld = 'M';
      String dateNew = 'F';

      expect(validateGender(dateOld), null);
      expect(validateGender(dateNew), null);

    });

    test('User options Validator', () {
      String string1 = '';

      expect(validateOptions(string1),'Por favor, introduzca su preferencia de notificaciones.');

      String dateOld = 'M';
      String dateNew = 'F';

      expect(validateOptions(dateOld), null);
      expect(validateOptions(dateNew), null);

    });

    test('User college Validator', () {
      String string1 = '';

      expect(validateCollege(string1),'Por favor, introduzca su número de colegio.');

      String dateOld = 'M';
      String dateNew = 'F';

      expect(validateCollege(dateOld), null);
      expect(validateCollege(dateNew), null);

    });


  });

  group('Test Application Validators', ()   {
    test('User Objetives Validator', () {
      String string1 = '';

      expect(validateText(string1),'Por favor, especificanos tus objetivos.');

      String string2 = 'Bien';

      expect(validateText(string2), null);

    });

    test('User Type Validator', () {
      String string1 = '';

      expect(validateMotivation(string1), 'Por favor, especificanos tus motivaciones.');

      String string2 = 'Bien';

      expect(validateMotivation(string2), null);

    });

  });

  group('Test AppointedMeal Validators', ()   {
    test('User Note Validator', () {
      String string1 = '';

      expect(validateNote(string1),'Por favor, introduzca una razón.');

      String string2 = 'Bien';

      expect(validateNote(string2), null);

    });

  });
  group('Test Dish Validators', ()   {
    test('User DishName Validator', () {
      String string1 = '';

      expect(validateDishName(string1),'Por favor, introduzca un nombre para el plato.');

      String string2 = 'Patatas';

      expect(validateDishName(string2), null);

    });

    test('User Instructions Validator', () {
      String string1 = '';

      expect(validateInstructions(string1), 'Por favor, introduzca sus instrucciones para el plato.');

      String string2 = 'Freir';

      expect(validateInstructions(string2), null);

    });

  });

  group('Test Message Validators', ()   {
    test('User Text Validator', () {
      String string1 = '';

      expect(validateMessageText(string1),'Introduzca un mensaje.');

      String string2 = 'Bien';

      expect(validateMessageText(string2), null);

    });

  });

}