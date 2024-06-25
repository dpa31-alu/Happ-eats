import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:happ_eats/pages/login.dart';

import '../services/auth_service.dart';
import '../utils/validators.dart';
import 'already_logged_redirect.dart';

class SignUpPatient extends StatefulWidget {
  const SignUpPatient ({super.key});

  @override
  SignUpPatientState createState() {
    return SignUpPatientState();
  }
}

class SignUpPatientState extends State<SignUpPatient> {

  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

  String _dropdownValue = "";
  String _dropdownValue2 = "";

  final _verifyPassword1 = TextEditingController();
  final _verifyPassword2 = TextEditingController();

  String _name = "";
  String _surname = "";
  String _password = "";
  String _email = "";
  String _tel = "";
  String _bday = "";
  String _height = "";
  String _weight = "";
  String _gender = "";
  String _medicalConditions = "";


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final UsersController controllerUser = UsersController(db: FirebaseFirestore.instance,  auth: AuthService(auth: FirebaseAuth.instance,));

    return  Scaffold(
      //resizeToAvoidBottomInset: false,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.small(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        body: SafeArea(

            child: Stack(
              children:
              [



                Positioned(
                  top: size.height * 0.3,

                  child:  Container(
                    height: size.height * 0.3,
                    width: size.width * 0.55,
                    decoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.45,
                  left: size.width * 0.7,
                  child:  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.70,
                    decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.65,
                  left: size.width * 0.10,
                  child:  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.80,
                    decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle
                    ),
                  ),
                ),

                /*
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, style: ElevatedButton.styleFrom(elevation:2,), child: const Icon(
                  Icons.arrow_back_ios_new_rounded, size: 25,)
                ),
*/


                Center(
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 200,
                        surfaceTintColor: Theme.of(context).colorScheme.background,
                        color: Colors.transparent,
                        child: Form(
                          key:_formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [

                                const Text("Bienvenido a Happ-eats,", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,),),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.395,
                                      child: TextFormField(
                                        validator: (value) {
                                          return validateName(value);
                                        },
                                        onSaved: (value){_name=value!;},
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Nombre',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.008),
                                    SizedBox(

                                      width: size.width * 0.395,
                                      child: TextFormField(
                                        validator: (value) {
                                          return validateSurname(value);
                                        },
                                        onSaved: (value){_surname=value!;},
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Apellidos',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(

                                  width: size.width * 0.8,
                                  child: TextFormField(
                                    validator: (value) {
                                      return validateEmail(value);
                                    },
                                    onSaved: (value){_email=value!;},
                                    keyboardType: TextInputType.emailAddress,
                                    maxLength: 32,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child:  TextFormField(
                                    validator: (value) {
                                      return validatePasswordOnSignUp(value, _verifyPassword2.text);
                                    },
                                    onSaved: (value){_password=value!;},
                                    controller: _verifyPassword1,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Contraseña',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child:  TextFormField(
                                    validator: (value) {
                                      return validatePasswordOnSignUp(value, _verifyPassword1.text);
                                    },
                                    controller: _verifyPassword2,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Repetir Contraseña',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child:  TextFormField(
                                    validator: (value) {
                                      return validatePhone(value);
                                    },
                                    onSaved: (value){_tel=value!;},
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Teléfono',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(

                                      width: size.width * 0.395,
                                      child: TextFormField(
                                        validator: (value) {
                                          return validateHeight(value);
                                        },
                                        onSaved: (value){_height=value!;},
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Altura (en centímetros)',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.008),
                                    SizedBox(

                                      width: size.width * 0.395,
                                      child: TextFormField(
                                        validator: (value) {
                                          return validateWeight(value);
                                        },
                                        onSaved: (value){_weight=value!;},
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Peso (en gramos)',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: size.width * 0.8,
                                    child: TextFormField(
                                        controller: _dateController,
                                        validator: (value) {
                                          return validateBirthday(value);
                                        },
                                        onSaved: (value){_bday=value!;},
                                        decoration: const InputDecoration(
                                            icon: Icon(Icons.calendar_today),
                                            labelText: "Introduce tu cumpleaños"
                                        ),
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              locale: const Locale("es", "ES"),
                                              initialDate: DateTime.now(),
                                              firstDate:DateTime(1940),
                                              lastDate: DateTime(2101)
                                          );
                                          if (pickedDate!=null) {
                                            _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                          }
                                        }
                                    )
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: TextFormField(
                                    validator: (value) {
                                      return validateMedicalConditions(value);
                                    },
                                    onSaved: (value){_medicalConditions=value!;},
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Estado médico',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: DropdownButtonFormField(
                                    value: _dropdownValue,
                                    items: const [
                                      DropdownMenuItem<String>(value: '', child: Text('Escoja su género')),
                                      DropdownMenuItem<String>(value: 'M', child: Text('Hombre')),
                                      DropdownMenuItem<String>(value: 'F', child: Text('Mujer')),
                                    ],
                                    onSaved: (value){_gender=value!;},
                                    validator: (value) {
                                      return validateGender(value);
                                    },
                                    onChanged: (String? value) {
                                      setState(() {
                                        _dropdownValue = value!;
                                      });
                                    },
                                  ),
                                ),
                                /*
                                const SizedBox(height: 10),

                                SizedBox(
                                  width: size.width * 0.8,
                                  child: DropdownButtonFormField(
                                    value: _dropdownValue2,
                                    items: const [
                                      DropdownMenuItem<String>(value: '', child: Text('Elija sus notificaciones.')),
                                      DropdownMenuItem<String>(value: '0', child: Text('Activar notificación de hidratación')),
                                      DropdownMenuItem<String>(value: '1', child: Text('No activar notificación de hidratación')),
                                    ],
                                    validator: (value) {
                                      return controllerUser.validateOptions(value);
                                    },
                                    onChanged: (String? value) {
                                      setState(() {
                                        _dropdownValue2 = value!;
                                      });
                                    },
                                  ),
                                ),*/



                                const SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: () async {

                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      String? result = await controllerUser.createUserPatient(_email, _password, _tel, _name, _surname, _bday,
                                          _gender, _medicalConditions, _weight, _height);

                                      if(result == null && context.mounted)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const RedirectLogin()),
                                          );
                                        }

                                      if(result!= null && context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(result)),
                                          );
                                        }

                                    }
                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Complete el formulario correctamente")),
                                      );
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("¿Ya tienes una cuenta?", style: TextStyle(fontSize: 14),),
                                    TextButton(onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginPage()),
                                      );
                                    },style: TextButton.styleFrom(

                                    ), child: const Text("Inicia sesión", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14))),

                                  ],
                                ),
                              ]
                          ) ,
                        ),
                      )
                    )
                ),
              ],
            )
        )
    );
  }
}