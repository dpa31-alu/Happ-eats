
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/diet_controller.dart';

import '../controllers/application_controller.dart';
import '../models/application.dart';
import '../models/appointed_meal.dart';
import '../models/diet.dart';
import '../models/message.dart';
import '../models/patient.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/file_service.dart';

class ApplicationProfessional extends StatefulWidget {
  const ApplicationProfessional({super.key});



  @override
  State<ApplicationProfessional> createState() => _ApplicationProfessionalState();
}

class _ApplicationProfessionalState extends State<ApplicationProfessional> {

  String _typeSelected = 'Peso';

  int _amount = 20;

  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.position.pixels == _scrollController!.position.maxScrollExtent)
        {
          setState(() {
            _amount += 20;
          });
        }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final ApplicationsController _controllerApplications = ApplicationsController(db: FirebaseFirestore.instance,
        auth: AuthService(auth: FirebaseAuth.instance,),
        file: FileService(auth: AuthService(auth: FirebaseAuth.instance,), storage: FirebaseStorage.instance),
        repositoryUser: UserRepository(db: FirebaseFirestore.instance),
        repositoryPatient: PatientRepository(db: FirebaseFirestore.instance),
        repositoryAppointedMeal: AppointedMealRepository(db: FirebaseFirestore.instance),
        repositoryApplication: ApplicationRepository(db: FirebaseFirestore.instance),
        repositoryMessages: MessageRepository(db: FirebaseFirestore.instance),
        repositoryDiets: DietRepository(db: FirebaseFirestore.instance));

    final DietsController controllerDiets = DietsController(db: FirebaseFirestore.instance, auth: AuthService(auth: FirebaseAuth.instance,));

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //leading: Icon(Icons.account_circle_rounded),
            title: const Text("Happ-eats - Professional"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Setting Icon',
                onPressed: () {},
              ),
            ]
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [


                    Column(
                        children: [
                          Container(
                          padding: const EdgeInsets.only(top: 10.0,),
                            child: const Text("Peticiones pendientes", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),),
                          ),


                          StreamBuilder(
                              stream: _controllerApplications.getApplicationsByTypeStream(_typeSelected, _amount),//FirebaseFirestore.instance.collection('applications').snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: size.height * 0.4,
                                        ),
                                        const CircularProgressIndicator(),
                                      ],
                                    ),
                                  );
                                }
                                else {
                                  return Column(
                                    children: [
                                      SizedBox(
                                      width: size.width * 0.8,
                                        child: DropdownButtonFormField(
                                          value: _typeSelected,
                                          items: const [
                                            DropdownMenuItem<String>(value: '', child: Text('Seleccione un modelo de dieta')),
                                            DropdownMenuItem<String>(value: 'Patología', child: Text('Dieta específica para una patología')),
                                            DropdownMenuItem<String>(value: 'Peso', child: Text('Bajar de peso')),
                                            DropdownMenuItem<String>(value: 'Musculatura', child: Text('Ganar musculatura')),
                                          ],
                                          onChanged: (String? value) {
                                            setState(() {
                                              _typeSelected = value!;
                                            });

                                          },
                                        ),
                                      ),


                                      ListView.builder(
                                        controller: _scrollController,
                                        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                        //physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:  snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                        return Card(
                                          child:  ExpansionTile(
                                          title: Text(snapshot.data.docs[index]['firstName'] + " " + snapshot.data.docs[index]['lastName']),
                                          subtitle: Text("Año de nacimiento: ${snapshot.data.docs[index]["birthday"].toDate().year.toString()} y género: ${snapshot.data.docs[index]["gender"]}"),
                                          leading: const Icon(Icons.account_circle),
                                          trailing: ElevatedButton(
                                                  onPressed: () async {
                                                    return showDialog(context: context, builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text("Confirmación"),
                                                        content: const Text("¿Añadir a este paciente a tu lista de pacientes?"),
                                                        actions: <Widget> [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text('Cancelar'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () async {
                                                              String? result = await controllerDiets.createDiet(snapshot.data.docs[index]['user'],
                                                                  snapshot.data.docs[index]['firstName'],
                                                                  snapshot.data.docs[index]['lastName'],
                                                                  snapshot.data.docs[index]['gender'],
                                                                  snapshot.data.docs[index]['medicalCondition'],
                                                                  snapshot.data.docs[index]['weight'],
                                                                  snapshot.data.docs[index]['height'],
                                                                  snapshot.data.docs[index]['birthday'].toDate(),
                                                                  snapshot.data.docs[index]['objectives'],
                                                                  snapshot.data.docs[index]['type']);

                                                              if(context.mounted)
                                                                {
                                                                  Navigator.pop(context);
                                                                }

                                                              if(result!=null&&context.mounted) {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  const SnackBar(content: Text("Error en la asignación")),
                                                                );
                                                              }
                                                              //(patient, firstName, lastName, gender, medicalCondition, weight, height, birthday, objectives, type)
                                                            },
                                                            child: const Text('Aceptar'),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    );
                                                  },
                                                  child: const Icon(Icons.add, size: 30,),
                                                ),
                                                children:<Widget>[
                                                  ListTile(
                                                    title: const Text("Condiciones médicas previas"),
                                                    subtitle: Text(snapshot.data.docs[index]["medicalCondition"].toString()),
                                                  ),
                                                  ListTile(
                                                    title: const Text("Objetivos"),
                                                    subtitle: Text(snapshot.data.docs[index]["objectives"].toString()),
                                                  ),
                                                  ListTile(
                                                    title: const Text("Altura"),
                                                    subtitle: Text(snapshot.data.docs[index]["height"].toString()),
                                                  ),
                                                  ListTile(
                                                    title: const Text("Peso"),
                                                    subtitle: Text(snapshot.data.docs[index]["weight"].toString()),
                                                  ),
                                                ],
                                      ),
                                      );
                                      },
                                      )




                                    ],
                                  );

                                }
                              }
                          ),
                        ],
                      )
                ],
              ),
            )
        )
    );
  }
}