import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/pages/login.dart';

import '../controllers/user_controller.dart';
import '../models/application.dart';
import '../models/appointed_meal.dart';
import '../models/diet.dart';
import '../models/dish.dart';
import '../models/message.dart';
import '../models/patient.dart';
import '../models/professional.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import 'already_logged_redirect.dart';

/// View for singing up a professional
class SignUpProfessional extends StatefulWidget {
  const SignUpProfessional ({super.key});

  @override
  SignUpProfessionalState createState() {
    return SignUpProfessionalState();
  }
}

class SignUpProfessionalState extends State<SignUpProfessional> {

  final _formKey = GlobalKey<FormState>();

  String _dropdownValue = "";

  final _verifyPassword1 = TextEditingController();
  final _verifyPassword2 = TextEditingController();

  String _name = "";
  String _surname = "";
  String _password = "";
  String _email = "";
  String _tel = "";
  String _collegeNumber = "";
  String _gender = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final UsersController controllerUsers = UsersController(
      db: FirebaseFirestore.instance,
      auth: AuthService(auth: FirebaseAuth.instance,),
      repositoryUser: UserRepository(db: FirebaseFirestore.instance),
      repositoryProfessional: ProfessionalRepository(db: FirebaseFirestore.instance),
      repositoryMessages: MessageRepository(db: FirebaseFirestore.instance),
      repositoryPatient: PatientRepository(db: FirebaseFirestore.instance),
      repositoryDish: DishRepository(db: FirebaseFirestore.instance),
      repositoryAppointedMeal: AppointedMealRepository(db: FirebaseFirestore.instance),
      repositoryApplication: ApplicationRepository(db: FirebaseFirestore.instance),
      repositoryDiets: DietRepository(db: FirebaseFirestore.instance),);

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
                  top: size.height * 0.1,

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
                  top: size.height * 0.40,
                  left: size.width * 0.4,
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
                  top: size.height * 0.1,
                  left: size.width * 0.30,
                  child:  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.80,
                    decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                /*ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, style: ElevatedButton.styleFrom(elevation:2,), child: const Icon(
                  Icons.arrow_back_ios_new_rounded, size: 25,)
                ),*/



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
                                SizedBox(
                                  width: size.width * 0.8,
                                  child:  TextFormField(
                                    validator: (value) {
                                      return validateCollege(value);
                                    },
                                    onSaved: (value){_collegeNumber=value!;},
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Número de colegio',
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
                                const SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: () async {

                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      String? result = await controllerUsers.createUserProfessional(_email, _password, _tel, _name,
                                          _surname, _collegeNumber, _gender);

                                      if(result == null&&context.mounted)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const RedirectLogin()),
                                        );
                                      }

                                      if(context.mounted){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(result!)),
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