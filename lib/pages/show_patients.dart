
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/diet_controller.dart';
import 'package:happ_eats/pages/chat.dart';
import 'package:happ_eats/utils/loading_dialog.dart';

import '../services/auth_service.dart';
import 'calendar_professional.dart';


class ShowPatients extends StatefulWidget {
  const ShowPatients({super.key});

  @override
  State<ShowPatients> createState() => _ShowPatientsState();
}

class _ShowPatientsState extends State<ShowPatients> {

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
              child:
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10.0,),
                        child: const Text("Tus pacientes: ", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,),),
                      ),
                      Divider(),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      StreamBuilder(
                          stream: controllerDiets.retrieveAllDiets(_typeSelected, _amount),
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
                            else if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.4,
                                    ),
                                    const Center(child: Text("No se han podido recuperar los pacientes"),),
                                  ],
                                ),
                              );
                            }
                            else if (!snapshot.hasData||snapshot.data.docs.length == 0) {
                              return Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.4,
                                    ),
                                    const Center(child: Text("No hay pacientes de esta categoría"),)
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
                                          subtitle: Text("Año de nacimiento: "  + snapshot.data.docs[index]["birthday"].toDate().year.toString() + " y género: " + snapshot.data.docs[index]["gender"]),
                                          leading: const Icon(Icons.account_circle),
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
                                              title: const Text("Altura y peso"),
                                              subtitle: Text(snapshot.data.docs[index]["height"].toString() + " " + snapshot.data.docs[index]["weight"].toString()),
                                            ),
                                            ListTile(
                                              title: const Text("Programar comidas: "),
                                              trailing: IconButton(
                                                    onPressed: () async {
                                                      DocumentSnapshot doc = snapshot.data.docs[index];
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) =>  CalendarProfessional(dietID: doc.id, professional: doc['professional'], patient: doc['patient'],)),
                                                      );
                                                    },
                                                    icon: const Icon(Icons.add, size: 30,),
                                                  ),
                                            ),
                                            ListTile(
                                              title:  const Text("Subir dieta: "),
                                              trailing: IconButton(
                                                onPressed: () async {
                                                  loadingDialog(context);
                                                  String? result = await controllerDiets.addFile(snapshot.data.docs[index].id);

                                                  if(result!=null && context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text("Error en la asignación")),
                                                    );
                                                  }

                                                  if(context.mounted) {
                                                    Navigator.pop(context);
                                                  }


                                                },
                                                icon: const Icon(Icons.add, size: 30,),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text("Chat: "),
                                              trailing: IconButton(
                                                onPressed: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) =>  ChatPage(currentUser: snapshot.data.docs[index]['professional'], otherUser: snapshot.data.docs[index]['patient'])),
                                                  );
                                                },
                                                icon: const Icon(Icons.add, size: 30,),
                                              ),
                                            )
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

            )
        )
    );
  }
}