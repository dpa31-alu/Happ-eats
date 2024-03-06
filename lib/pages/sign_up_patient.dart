import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:happ_eats/pages/login.dart';


class SignUpPatient extends StatefulWidget {
  const SignUpPatient ({super.key});

  @override
  SignUpPatientState createState() {
    return SignUpPatientState();
  }
}

class SignUpPatientState extends State<SignUpPatient> {

  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  String dropdownValue = "";
  String dropdownValue2 = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Scaffold(
      //resizeToAvoidBottomInset: false,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10.0),
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

                /*
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, style: ElevatedButton.styleFrom(elevation:2,), child: const Icon(
                  Icons.arrow_back_ios_new_rounded, size: 25,)
                ),
*/


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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(

                                    width: size.width * 0.395,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, introduzca su altura.';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Altura',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.008),
                                  SizedBox(

                                    width: size.width * 0.395,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, introduzca su peso.';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Peso',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: size.width * 0.8,
                                child: TextFormField(
                                    controller: dateController,
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                        return 'Por favor, introduzca su cumpleaños.';
                                        }
                                        return null;
                                    },
                                    decoration: const InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelText: "Introduce tu cumpleaños"
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate:DateTime(1940),
                                          lastDate: DateTime(2101)
                                      );
                                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate!);
                                    }
                                )
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                  width: size.width * 0.8,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, introduzca sus condiciones médicas previas.';
                                      }
                                      return null;
                                    },
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
                                   value: dropdownValue,
                                   items: const [
                                     DropdownMenuItem<String>(child: Text('Escoja su género'), value: ''),
                                     DropdownMenuItem<String>(child: Text('Hombre'), value: '0'),
                                     DropdownMenuItem<String>(child: Text('Mujer'), value: '1'),
                                   ],
                                   validator: (value) {
                                     if (value == '') {
                                       return 'Por favor, introduzca su género.';
                                     }
                                     return null;
                                   },
                                   onChanged: (String? value) {
                                     setState(() {
                                       dropdownValue = value!;
                                     });
                                   },
                                 ),
                               ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: size.width * 0.8,
                                child: DropdownButtonFormField(
                                  value: dropdownValue2,
                                  items: const [
                                    DropdownMenuItem<String>(child: Text('Elija sus notificaciones.'), value: ''),
                                    DropdownMenuItem<String>(child: Text('Activar notificación de hidratación'), value: '0'),
                                    DropdownMenuItem<String>(child: Text('No activar notificación de hidratación'), value: '1'),
                                  ],
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Por favor, introduzca su preferencia de notificaciones.';
                                    }
                                    return null;
                                  },
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue2 = value!;
                                    });
                                  },
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