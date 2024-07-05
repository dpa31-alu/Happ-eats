import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/pages/already_logged_redirect.dart';
import 'package:happ_eats/pages/sign_up_selector.dart';

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

/// View for login in users
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {

    final UsersController controllerUser = UsersController(
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
    final Size size = MediaQuery.of(context).size;

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
                  top: size.height * 0.7,

                  child:  Container(
                    height: size.height * 0.3,
                    width: size.width * 0.55,
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.55,
                  left: size.width * 0.30,
                  child:  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.70,
                    decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.35,
                  left: size.width * 0.10,
                  child:  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.80,
                    decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        shape: BoxShape.circle
                    ),
                  ),
                ),


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

                                const Text("Bienvenido de vuelta,", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,),),
                                const SizedBox(height: 20),
                                SizedBox(

                                  width: size.width * 0.8,
                                  child: TextFormField(

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

                                    onSaved: (value){_password=value!;},
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Contraseña',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: () async {

                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      String? result = await controllerUser.loginUser(_email, _password);

                                      if(result == null&&context.mounted)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const RedirectLogin()),
                                        );
                                      }

                                      if (result!=null&&context.mounted)
                                        {
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
                                  child: const Text('Enviar'),
                                ),
                                /*TextButton(onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PasswordRecovery()),
                                  );
                                },
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ), child: const Text("¿Has olvidado tu contraseña?", style: TextStyle( fontStyle: FontStyle.italic, fontSize: 14)),),
                                */Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("¿Acabas de llegar?", style: TextStyle(fontSize: 14),),
                                    TextButton(onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignUpSelector()),
                                      );
                                    },style: TextButton.styleFrom(

                                    ), child: const Text("Crea una cuenta", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14))),

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