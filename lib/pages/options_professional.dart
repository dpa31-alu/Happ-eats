import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/user_controller.dart';
import 'package:happ_eats/utils/loading_dialog.dart';

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

/// View for displaying the professional data and updating it, and deleting the account
class OptionsProfessional extends StatefulWidget {

  const OptionsProfessional({super.key});



  @override
  OptionsProfessionalState createState() {
    return OptionsProfessionalState();
  }
}

class OptionsProfessionalState extends State<OptionsProfessional> {

  final UsersController _controllerUsers = UsersController(
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

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();

  late Stream _stateUser;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _stateUser = _controllerUsers.getUserData()!;
    super.initState();
  }

  String _dropdownValue = "";

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RedirectLogin()),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ) ,
          title: const Text("Happ-eats"),
        ),
        body: SafeArea(
            child:  StreamBuilder(
                stream: _stateUser,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                  {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator(),)
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("No se han podido recuperar tus datos"),)
                      ],
                    );
                  }
                  else if (snapshot.data != null) {

                    String firstName = snapshot.data.firstName;
                    String lastName = snapshot.data.lastName;
                    String gender = snapshot.data.gender;
                    String tel = snapshot.data.tel;

                    return SingleChildScrollView(
                                      child: Center(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Card.outlined(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0, top: 5.0),
                                                    child: Column(
                                                      children: [
                                                        const Text('Tus datos:', style: TextStyle(fontSize: 25.0),),
                                                        const Divider(),
                                                        ListTile(
                                                          title: Text("Nombre: $firstName"),
                                                          trailing: IconButton(onPressed: () async {
                                                            showDialog(context: context, builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: const Text("Actualice su nombre"),
                                                                content: Form(
                                                                    key: _formKey,
                                                                    child:
                                                                    Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        TextFormField(
                                                                          controller: _nameController,
                                                                          validator: (value) {
                                                                            return validateName(value);
                                                                          },
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: 'Nombre',
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Cancelar'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                String? result;
                                                                                if (_formKey.currentState!.validate())  {
                                                                                  loadingDialog(context);
                                                                                  result = await _controllerUsers.updateUserFirstName(_nameController.text, {});
                                                                                  if(context.mounted)
                                                                                  {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                    if (result!=null)
                                                                                    {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(content: Text(result)),
                                                                                      );
                                                                                    }
                                                                                    else {
                                                                                      setState(() {
                                                                                        _stateUser= _controllerUsers.getUserData()!;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    const SnackBar(content: Text("Añade un valor nuevo para actualizar")),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: const Text('Aceptar'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                ),
                                                              );
                                                            }
                                                            );
                                                          }, icon: const Icon(Icons.update_sharp)),
                                                        ),
                                                        const Divider(),
                                                        ListTile(
                                                          title: Text("Apellidos: $lastName"),
                                                          trailing: IconButton(onPressed: () async {
                                                            showDialog(context: context, builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: const Text("Actualice sus apellidos"),
                                                                content: Form(
                                                                    key: _formKey,
                                                                    child:
                                                                    Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        TextFormField(
                                                                          controller: _surnameController,
                                                                          validator: (value) {
                                                                            return validateSurname(value);
                                                                          },
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: 'Apellidos',
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Cancelar'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                String? result;
                                                                                if (_formKey.currentState!.validate())  {
                                                                                  loadingDialog(context);
                                                                                  result = await _controllerUsers.updateUserLastName(_surnameController.text, {});
                                                                                  if(context.mounted)
                                                                                  {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                    if (result!=null)
                                                                                    {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(content: Text(result)),
                                                                                      );
                                                                                    }
                                                                                    else {
                                                                                      setState(() {
                                                                                        _stateUser = _controllerUsers.getUserData()!;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    const SnackBar(content: Text("Añade un valor nuevo para actualizar")),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: const Text('Aceptar'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                ),
                                                              );
                                                            }
                                                            );
                                                          }, icon: const Icon(Icons.update_sharp)),
                                                        ),
                                                        const Divider(),
                                                        ListTile(
                                                          title: Text("Género: $gender"),
                                                          trailing: IconButton(onPressed: () async {
                                                            showDialog(context: context, builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: const Text("Actualice su género"),
                                                                content: Form(
                                                                    key: _formKey,
                                                                    child:
                                                                    Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        DropdownButtonFormField(
                                                                          value: _dropdownValue,
                                                                          items: const [
                                                                            DropdownMenuItem<String>(value: '', child: Text('Escoja su género')),
                                                                            DropdownMenuItem<String>(value: 'M', child: Text('Hombre')),
                                                                            DropdownMenuItem<String>(value: 'F', child: Text('Mujer')),
                                                                          ],
                                                                          validator: (value) {
                                                                            return validateGender(value);
                                                                          },
                                                                          onChanged: (String? value) {
                                                                            setState(() {
                                                                              if(value==null)
                                                                              {
                                                                                _dropdownValue = '';
                                                                              }
                                                                              else {
                                                                                _dropdownValue = value;
                                                                              }
                                                                            });
                                                                          },
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Cancelar'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                if (_formKey.currentState!.validate())  {
                                                                                  loadingDialog(context);
                                                                                  String? result = await _controllerUsers.updatePatientGender(_dropdownValue, {}, false);
                                                                                  if(context.mounted)
                                                                                  {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                    if (result!=null)
                                                                                    {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(content: Text(result)),
                                                                                      );
                                                                                    }
                                                                                    else {
                                                                                      setState(() {
                                                                                        _stateUser= _controllerUsers.getUserData()!;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    const SnackBar(content: Text("Añade un valor nuevo para actualizar")),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: const Text('Aceptar'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                ),
                                                              );
                                                            }
                                                            );
                                                          }, icon: const Icon(Icons.update_sharp)),
                                                        ),
                                                        const Divider(),
                                                        ListTile(
                                                          title: Text("Teléfono: $tel"),
                                                          trailing: IconButton(onPressed: () async {
                                                            showDialog(context: context, builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: const Text("Actualice su teléfono"),
                                                                content: Form(
                                                                    key: _formKey,
                                                                    child:
                                                                    Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        TextFormField(
                                                                          controller: _phoneController,
                                                                          validator: (value) {
                                                                            return validatePhone(value);
                                                                          },
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: 'Teléfono',
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Cancelar'),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                String? result;
                                                                                if (_formKey.currentState!.validate())  {
                                                                                  loadingDialog(context);
                                                                                  result = await _controllerUsers.updateUserTel(_phoneController.text);
                                                                                  if(context.mounted)
                                                                                  {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                    if (result!=null)
                                                                                    {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(content: Text(result)),
                                                                                      );
                                                                                    }
                                                                                    else {
                                                                                      setState(() {
                                                                                        _stateUser = _controllerUsers.getUserData()!;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    const SnackBar(content: Text("Añade un valor nuevo para actualizar")),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: const Text('Aceptar'),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                ),
                                                              );
                                                            }
                                                            );
                                                          },
                                                              icon: const Icon(Icons.update_sharp)),
                                                        ),
                                                        const Divider(),


                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            return showDialog(context: context, builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: const Text("Confirmación"),
                                                                content: const Text("¿Desea borrar su cuenta?"),
                                                                actions: <Widget> [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: const Text('Cancelar'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () async {

                                                                      loadingDialog(context);
                                                                      String? result = await _controllerUsers.deleteUserProfessional();
                                                                      if(context.mounted)
                                                                      {
                                                                        Navigator.pop(context);
                                                                      }


                                                                      if (result == null)
                                                                      {
                                                                        if(context.mounted) {
                                                                          Navigator.pop(context);
                                                                          Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => const RedirectLogin()),
                                                                          );
                                                                        }
                                                                      }
                                                                      else {
                                                                        if(context.mounted) {
                                                                          Navigator.pop(context);
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(content: Text(result),)
                                                                          );
                                                                        }
                                                                      }
                                                                    },
                                                                    child: const Text('Aceptar'),
                                                                  ),
                                                                ],
                                                              );
                                                            }
                                                            );
                                                          },
                                                          child: const Text('Borrar Usuario'),
                                                        ),

                                                      ],
                                                    ),
                                                  )
                                              ),
                                            ]
                                        ) ,
                                      )

                                  );

                  } else {return const Text('Error');}
                })

        )
    );
  }


}