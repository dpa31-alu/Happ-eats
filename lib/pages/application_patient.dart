import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/application_controller.dart';
import 'package:happ_eats/controllers/diet_controller.dart';
import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/appointed_meal.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:happ_eats/models/message.dart';
import 'package:happ_eats/models/user.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:happ_eats/services/file_service.dart';
import 'package:happ_eats/utils/loading_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/patient.dart';
import '../utils/validators.dart';


/// View for creating applications, displaying their info and status, and deleting them. It also allows for the download of the diet file.
class ApplicationPatient extends StatefulWidget {
  const ApplicationPatient({super.key});

  @override
  ApplicationPatientState createState() {
    return ApplicationPatientState();
  }
}

class ApplicationPatientState extends State<ApplicationPatient> {

   final _formKey = GlobalKey<FormState>();




   final ApplicationsController _controllerApplications = ApplicationsController(db: FirebaseFirestore.instance,
       auth: AuthService(auth: FirebaseAuth.instance,),
       file: FileService(auth: AuthService(auth: FirebaseAuth.instance,), storage: FirebaseStorage.instance),
       repositoryUser: UserRepository(db: FirebaseFirestore.instance),
       repositoryPatient: PatientRepository(db: FirebaseFirestore.instance),
       repositoryAppointedMeal: AppointedMealRepository(db: FirebaseFirestore.instance),
       repositoryApplication: ApplicationRepository(db: FirebaseFirestore.instance),
       repositoryMessages: MessageRepository(db: FirebaseFirestore.instance),
       repositoryDiets: DietRepository(db: FirebaseFirestore.instance));

   final DietsController _controllerDiets = DietsController(db: FirebaseFirestore.instance,
       auth: AuthService(auth: FirebaseAuth.instance,),
       file: FileService(auth: AuthService(auth: FirebaseAuth.instance,), storage: FirebaseStorage.instance),
       repositoryUser: UserRepository(db: FirebaseFirestore.instance),
       repositoryMessages: MessageRepository(db: FirebaseFirestore.instance),
       repositoryApplication: ApplicationRepository(db: FirebaseFirestore.instance),
       repositoryDiets: DietRepository(db: FirebaseFirestore.instance));





   late Stream _stateApplication;

   @override
  void initState() {
     _stateApplication = _controllerApplications.getApplicationForUserState();
    super.initState();
  }

  String _dropdownValue = "";

  String _objectives = "";
  String _type = "";

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;



    return Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //leading: Icon(Icons.account_circle_rounded),
            title: const Text("Happ-eats"),
        ),
        body: SafeArea(
            child:  StreamBuilder(
              stream: _stateApplication,
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
                      Center(child: Text('No se ha podido recuperar el formulario o dieta'),)
                    ],
                  );
                }
                else if (snapshot.data.toString() == '{}') {
                    return SingleChildScrollView(
                        child: Center(
                          child: Form(
                            key:_formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [

                                  const Text("Cuentanos tus objetivos,", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,),),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    height: size.height * 0.5,
                                    child: TextFormField(
                                      validator: (value) {
                                       return validateText(value);
                                      },
                                      onSaved: (value){_objectives=value!;},
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      minLines: null,
                                      maxLines: null,
                                      expands: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),

                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: DropdownButtonFormField(
                                      value: _dropdownValue,
                                      items: const [
                                        DropdownMenuItem<String>(value: '', child: Text('Seleccione un modelo de dieta')),
                                        DropdownMenuItem<String>(value: 'Patología', child: Text('Dieta específica para una patología')),
                                        DropdownMenuItem<String>(value: 'Peso', child: Text('Bajar de peso')),
                                        DropdownMenuItem<String>(value: 'Musculatura', child: Text('Ganar musculatura')),
                                      ],
                                      onSaved: (value){_type=value!;},
                                      validator: (value) {
                                        return validateMotivation(value);
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
                                        try{
                                          return showDialog(context: context, builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirmación"),
                                              content: const Text("¿Es esta tu solicitud?"),
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
                                                    String? result = await _controllerApplications.createApplication(_objectives, _type);
                                                    if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }

                                                    if (result == null) {
                                                        if(context.mounted)
                                                          {
                                                            Navigator.pop(context);
                                                            setState(() {
                                                              _stateApplication = _controllerApplications.getApplicationForUserState();
                                                            });
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

                                        }
                                        on FirebaseAuthException catch (ex) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(ex.code)),
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
                                ]
                            ) ,
                          ),
                        )

                    );
                  }
                else if (snapshot.data['state'] == 'Pending') {

                    return SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * 0.025,
                            ),
                            const Text("Tu solicitud en progreso", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,),),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            const Text("Si desea modificar su solicitud. cancele la actual", style: TextStyle(fontSize: 15.0),),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            Card.outlined(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0, top: 5.0),
                                  child: Column(
                                    children: [
                                      const Text('Tu solicitud:', style: TextStyle(fontSize: 25.0),),
                                      const Divider(),
                                      ListTile(
                                        title: const Text("Fecha de la solicitud:"),
                                        trailing: Text(snapshot.data['date'].toDate().toString(), style: const TextStyle(fontSize: 15.0),),
                                      ),
                                      ListTile(
                                        title: const Text("Tipo de la solicitud:"),
                                        trailing: Text(snapshot.data['type'], style: const TextStyle(fontSize: 15.0),),
                                      ),
                                      const Divider(),
                                      Column(
                                        children: [
                                          const Text('Objetivos:', style: TextStyle(fontSize: 20.0),),
                                          Text(snapshot.data['objectives']),
                                        ],
                                      ),
                                      const Divider(),

                                      ElevatedButton(
                                        onPressed: () async {
                                          return showDialog(context: context, builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirmación"),
                                              content: const Text("¿Desea cancelar su solicitud?"),
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
                                                    String? result = await _controllerApplications.cancelApplication( snapshot.data['uid'] ,null);
                                                    if(context.mounted)
                                                    {
                                                      Navigator.pop(context);
                                                    }


                                                    if (result == null)
                                                    {
                                                      if(context.mounted) {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          _stateApplication = _controllerApplications.getApplicationForUserState();
                                                        });
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
                                        child: const Text('Cancelar solicitud'),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            SizedBox(
                              height: size.height * 0.25,
                            ),

                          ],
                        ),
                      )


                    );
                  }
                else if (snapshot.data['state']=='Accepted') {
                   return SingleChildScrollView(
                       child: Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SizedBox(
                               height: size.height * 0.025,
                             ),
                             const Align(
                               alignment: Alignment.center,
                               child: Text("Tu solicitud ha sido aprobada", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,),),
                             ),
                             SizedBox(
                               height: size.height * 0.05,
                             ),
                             const Text("Si desea, puede cancelar su dieta", style: TextStyle(fontSize: 15.0),),
                             SizedBox(
                               height: size.height * 0.05,
                             ),

                             Card.outlined(
                                 child: Padding(
                                   padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0, top: 5.0),
                                   child: Column(
                                     children: [
                                       const Text('Tu solicitud:', style: TextStyle(fontSize: 25.0),),
                                       const Divider(),
                                       ListTile(
                                         title: const Text("Fecha de la solicitud:"),
                                         trailing: Text(snapshot.data['date'].toDate().toString(), style: const TextStyle(fontSize: 15.0),),
                                       ),
                                       ListTile(
                                         title: const Text("Tipo de la solicitud:"),
                                         trailing: Text(snapshot.data['type'], style: const TextStyle(fontSize: 15.0),),
                                       ),
                                       const Divider(),
                                       Column(
                                         children: [
                                           const Text('Objetivos:', style: TextStyle(fontSize: 20.0),),
                                           Text(snapshot.data['objectives']),
                                         ],
                                       ),
                                       const Divider(),

                                       ElevatedButton(
                                         onPressed: () async {
                                           return showDialog(context: context, builder: (BuildContext context) {
                                             return AlertDialog(
                                               title: const Text("Confirmación"),
                                               content: const Text("¿Desea cancelar su solicitud, esto cancelará también su dieta?"),
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
                                                     Map<String, dynamic> diet = await _controllerDiets.retrieveDietForUser();
                                                     String? result = await _controllerApplications.cancelApplication(snapshot.data['uid'] , diet);
                                                     if(context.mounted)
                                                     {
                                                       Navigator.pop(context);
                                                     }

                                                     if (result == null)
                                                     {
                                                       if(context.mounted) {
                                                         Navigator.pop(context);
                                                         setState(() {
                                                           _stateApplication = _controllerApplications.getApplicationForUserState();
                                                         });
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
                                         child: const Text('Cancelar solicitud'),
                                       ),
                                     ],
                                   ),
                                 )
                             ),
                             SizedBox(
                               height: size.height * 0.1,
                             ),
                             Card.outlined(
                               child: Padding(
                                 padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0, top: 5.0),
                                 child: Column(
                                   children: [
                                     const Text('Para descargar su dieta, haga click aquí'),
                                     IconButton(
                                       onPressed: () async {
                                         loadingDialog(context);
                                         Map diet = await _controllerDiets.retrieveDietForUser();
                                         String? result = "Todavía no se ha asignado una archivo a su dieta";
                                         String? urlDownload;
                                         if (diet.isNotEmpty&&diet['url']!=null) {

                                             urlDownload = await _controllerDiets.downloadFile(diet['url'], diet['professional'], diet['patient']);

                                            if (urlDownload != null)
                                              {
                                                Uri url = Uri.parse(urlDownload);
                                                launchUrl(url);
                                              }
                                         }
                                         if(context.mounted)
                                         {
                                           Navigator.pop(context);
                                         }
                                         if(context.mounted&&urlDownload==null)
                                           {
                                             ScaffoldMessenger.of(context).showSnackBar(
                                                 SnackBar(content: Text(result),)
                                             );
                                           }
                                       },
                                       icon: const Icon(Icons.download_sharp),
                                     ),
                                   ],
                                 ),
                               )

                             ),


                           ],
                         ),
                       )


                   );
                  } else {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text('Error'),)
                    ],
                  );
                }

              })

        )
    );
  }


}