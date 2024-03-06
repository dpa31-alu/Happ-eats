import 'package:flutter/material.dart';
import 'package:happ_eats/pages/login.dart';


class SignUpProfessional extends StatefulWidget {
  const SignUpProfessional ({super.key});

  @override
  SignUpProfessionalState createState() {
    return SignUpProfessionalState();
  }
}

class SignUpProfessionalState extends State<SignUpProfessional> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return  Scaffold(
      //resizeToAvoidBottomInset: false,
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
                        color: Colors.lightBlue,
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
                        color: Colors.lightBlueAccent,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, style: ElevatedButton.styleFrom(elevation:2,), child: const Icon(
                  Icons.arrow_back_ios_new_rounded, size: 25,)
                ),



                Center(
                    child: SingleChildScrollView(
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
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, introduzca su nombre.';
                                        }
                                        return null;
                                      },
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
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, introduzca sus apellidos.';
                                        }
                                        return null;
                                      },
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
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, introduzca su email.';
                                    }
                                    return null;
                                  },
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
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, introduzca su contraseña.';
                                    }
                                    return null;
                                  },
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
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, repita su contraseña.';
                                    }
                                    return null;
                                  },
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
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, introduzca su teléfono.';
                                    }
                                    return null;
                                  },
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
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, introduzca su número de colegio.';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Número de colegio',
                                  ),
                                ),
                              ),




                              const SizedBox(height: 25),
                              ElevatedButton(
                                onPressed: () {

                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Procesando')),
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
                ),
              ],
            )
        )
    );
  }
}