import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/diet_controller.dart';
import 'package:happ_eats/controllers/user_controller.dart';
import 'package:happ_eats/utils/loading_dialog.dart';
import 'package:intl/intl.dart';

import '../models/application.dart';
import '../models/appointed_meal.dart';
import '../models/diet.dart';
import '../models/dish.dart';
import '../models/message.dart';
import '../models/patient.dart';
import '../models/professional.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/file_service.dart';
import '../utils/calculateBMI.dart';
import '../utils/validators.dart';
import 'already_logged_redirect.dart';


class OptionsPatient extends StatefulWidget {

  const OptionsPatient({super.key});



  @override
  OptionsPatientState createState() {
    return OptionsPatientState();
  }
}

class OptionsPatientState extends State<OptionsPatient> {

  final DietsController _controllerDiets = DietsController(db: FirebaseFirestore.instance,
      auth: AuthService(auth: FirebaseAuth.instance,),
      file: FileService(auth: AuthService(auth: FirebaseAuth.instance,), storage: FirebaseStorage.instance),
      repositoryUser: UserRepository(db: FirebaseFirestore.instance),
      repositoryMessages: MessageRepository(db: FirebaseFirestore.instance),
      repositoryApplication: ApplicationRepository(db: FirebaseFirestore.instance),
      repositoryDiets: DietRepository(db: FirebaseFirestore.instance));

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
  final _birthdayController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _medicalConditionsController = TextEditingController();

  late Stream _stateUser;
  late Stream _statePatient;
  late Stream _stateDiet;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _stateUser = _controllerUsers.getUserData()!;
    _statePatient = _controllerUsers.getPatientData();
    _stateDiet = _controllerDiets.retrieveDietForUserStream();
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
                  else if (snapshot.hasError) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("No se han podido recuperar tus datos"),)
                      ],
                    );
                  }
                  else if (snapshot.data != null) {
                    return StreamBuilder(
                    stream: _statePatient,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
                      if (snapshot2.connectionState == ConnectionState.waiting)
                      {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator(),)
                          ],
                        );
                      }
                      else if (snapshot.hasError) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text("No se han podido recuperar tus datos"),)
                          ],
                        );
                      }
                      else if (snapshot2.data != null) {
                        return StreamBuilder(
                        stream: _stateDiet,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot3) {

                          bool diet = false;
                          if (snapshot3.data.toString() != '{}')
                            {
                              diet = true;
                            }

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
                                                  title: Text("Nombre: ${snapshot.data.firstName}"),
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
                                                                          result = await _controllerUsers.updateUserFirstName(_nameController.text, diet);
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
                                                  title: Text("Apellidos: ${snapshot.data.lastName}"),
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
                                                                          result = await _controllerUsers.updateUserLastName(_surnameController.text, diet);
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
                                                                                _statePatient = _controllerUsers.getPatientData();
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
                                                  title: Text("Género: ${snapshot.data.gender}"),
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
                                                                          String? result = await _controllerUsers.updatePatientGender(_dropdownValue, diet, true);
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
                                                                                _statePatient = _controllerUsers.getPatientData();
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
                                                  title: Text("Teléfono: ${snapshot.data.tel}"),
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
                                                                                _statePatient = _controllerUsers.getPatientData();
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
                                                ListTile(
                                                  title: Text("Cumpleaños: ${snapshot2.data.birthday.day}/${snapshot2.data.birthday.month}/${snapshot2.data.birthday.year} "),
                                                  trailing: IconButton(onPressed: () async {
                                                    showDialog(context: context, builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text("Actualice su cumpleaños"),
                                                        content: Form(
                                                            key: _formKey,
                                                            child:
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                TextFormField(
                                                                    controller: _birthdayController,
                                                                    validator: (value) {
                                                                      return validateBirthday(value);
                                                                    },
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
                                                                        _birthdayController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                                                      }
                                                                    }
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
                                                                          result = await _controllerUsers.updatePatientBirthday(_birthdayController.text, diet);
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
                                                                                _statePatient = _controllerUsers.getPatientData();
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
                                                ListTile(
                                                  title: Text("Peso: ${snapshot2.data.weight.toStringAsFixed(2)}"),
                                                  trailing: IconButton(onPressed: () async {
                                                    showDialog(context: context, builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text("Actualice su peso"),
                                                        content: Form(
                                                            key: _formKey,
                                                            child:
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                TextFormField(
                                                                  controller: _weightController,
                                                                  validator: (value) {
                                                                    return validateWeight(value);
                                                                  },
                                                                  decoration: const InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    labelText: 'Peso en kg',
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
                                                                          result = await _controllerUsers.updatePatientWeight(_weightController.text, diet);
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
                                                                                _statePatient = _controllerUsers.getPatientData();
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
                                                ListTile(
                                                  title: Text("Peso Inicial: ${snapshot2.data.startingWeight.toStringAsFixed(2)}"),
                                                ),
                                                const Divider(),
                                                ListTile(
                                                  title: Text("Altura: ${snapshot2.data.height.toStringAsFixed(2)}"),
                                                  trailing: IconButton(onPressed: () async {
                                                    showDialog(context: context, builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text("Actualice su peso"),
                                                        content: Form(
                                                            key: _formKey,
                                                            child:
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                TextFormField(
                                                                  controller: _heightController,
                                                                  validator: (value) {
                                                                    return validateHeight(value);
                                                                  },
                                                                  decoration: const InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    labelText: 'Altura en cm',
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
                                                                          result = await _controllerUsers.updatePatientHeight(_heightController.text, diet);
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
                                                                                _statePatient = _controllerUsers.getPatientData();
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
                                                ListTile(
                                                  title: Text("BMI: ${calculateBMI(snapshot2.data.height, snapshot2.data.weight).toStringAsFixed(2)}"),
                                                  //trailing: Text(snapshot.data['type'], style: const TextStyle(fontSize: 15.0),),
                                                ),
                                                const Divider(),
                                                Column(
                                                  children: [
                                                    const Text('Condiciones Médicas:', style: TextStyle(fontSize: 20.0),),
                                                    Text(snapshot2.data.medicalCondition),
                                                    IconButton(onPressed: () async {
                                                      showDialog(context: context, builder: (BuildContext context) {
                                                        return AlertDialog(
                                                            title: const Text("Actualice su peso"),
                                                            content: SingleChildScrollView(
                                                              child:  Form(
                                                                  key: _formKey,
                                                                  child:
                                                                  Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      TextFormField(
                                                                        controller: _medicalConditionsController,
                                                                        validator: (value) {
                                                                          return validateMedicalConditions(value);
                                                                        },
                                                                        textInputAction: TextInputAction.newline,
                                                                        keyboardType: TextInputType.multiline,
                                                                        minLines: null,
                                                                        maxLines: null,
                                                                        decoration: const InputDecoration(
                                                                          border: OutlineInputBorder(),
                                                                          labelText: 'Condiciones médicas previas',
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
                                                                                result = await _controllerUsers.updatePatientMedicalCondition(_heightController.text, diet);
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
                                                                                      _statePatient = _controllerUsers.getPatientData();
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
                                                            )
                                                        );
                                                      }
                                                      );
                                                    },
                                                        icon: const Icon(Icons.update_sharp)),
                                                  ],
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
                                                              String? result = await _controllerUsers.deleteUserPatient();
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
                        });
                      }
                      else {return const Text('Error');}
                    });
                  } else {return const Text('Error');}
                })

        )
    );
  }


}