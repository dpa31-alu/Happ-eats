
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/diet_controller.dart';
import 'package:happ_eats/pages/application_patient.dart';
import 'package:happ_eats/pages/calendar_patient.dart';
import 'package:happ_eats/pages/chat.dart';
import 'package:happ_eats/pages/dictionary.dart';
import 'package:happ_eats/pages/user_recipes.dart';
import 'package:happ_eats/pages/progress_tracker.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:happ_eats/utils/loading_dialog.dart';


import '../controllers/user_controller.dart';
import 'options_patient.dart';


class MenuPatient extends StatefulWidget {
   const MenuPatient({super.key});

  @override
  State<MenuPatient> createState() => _MenuPatientState();
}

class _MenuPatientState extends State<MenuPatient> {
   final GlobalKey<ScaffoldState> _key = GlobalKey();

   final UsersController controllerUser = UsersController(db: FirebaseFirestore.instance, auth: AuthService(auth: FirebaseAuth.instance,));

   final AuthService auth =  AuthService(auth: FirebaseAuth.instance,);

   late String _displayName = "";

   late String _firstName = "";

   late String _lastName = "";

   late String _gender = "";

   @override
  void initState() {

    getNameInitialized();

    super.initState();
  }

  void getNameInitialized() async {
    Map<String, dynamic>? result = await controllerUser.getCurrentUserNames();
    if(result!=null)
      {
        setState(() {
          _displayName = "${result['firstName']} ${result['lastName']}";
          _firstName = result['firstName'];
          _lastName = result['lastName'];
          _gender = "${result['gender']}";
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key : _key,
      //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Happ-eats"),
          actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home_sharp),
                tooltip: 'Icono home',
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
              ),
            ],
        ),
        drawer: Drawer(
          child:  ListView(
            padding: EdgeInsets.zero,
            children: [
               UserAccountsDrawerHeader(
                accountEmail:  Text(_displayName, style: const TextStyle(fontSize: 24.0),),
                accountName: (_gender=='M') ? const Text(
                  "Bienvenido, ",
                  style: TextStyle(fontSize: 24.0),
                ) : const Text(
                  "Bienvenida, ",
                  style: TextStyle(fontSize: 24.0),
                ) ,
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings_sharp),
                title: const Text(
                  'Opciones',
                  style: TextStyle(fontSize: 24.0),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  OptionsPatient())
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_sharp),
                title: const Text(
                  'Salir',
                  style: TextStyle(fontSize: 24.0),
                ),
                onTap: () async {
                  loadingDialog(context);
                  String? result = await controllerUser.logoutUser();
                  if(context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: GridView(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                ),
                children: [
                  /*TextButton(onPressed: () async {
                    IngredientsController pepe = IngredientsController();
                    pepe.crearCosis();
                  }, child: const Text('subir subidas')),*/

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () async {
                      DietsController controllerDiets = DietsController(db: FirebaseFirestore.instance,  auth: AuthService(auth: FirebaseAuth.instance,));
                      Map<dynamic, dynamic> userDiet = await controllerDiets.retrieveDietForUser();



                      if(userDiet.isEmpty&&context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Se necesita un nutricionista asignado primero"),)
                        );
                      }
                      else if (context.mounted){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  CalendarPatient(dietID: userDiet['uid']))
                        );
                      }
                    },
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet_sharp, size: 80,),
                          Text("Calendario", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,))
                        ]
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserRecipes()),
                      );
                    },
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.ad_units_sharp, size: 80,),
                          Text("Recetas", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,))
                        ]
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ApplicationPatient()),
                      );
                    },
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.note_alt_sharp, size: 80,),
                          Text("Dieta", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,))
                        ]
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Dictionary()),
                      );
                    },
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_sharp, size: 80,),
                          Text("Diccionario", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,))
                        ]
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: ()  async {
                      DietsController controllerDiets = DietsController(db: FirebaseFirestore.instance,  auth: AuthService(auth: FirebaseAuth.instance,));
                      Map<dynamic, dynamic> userDiet = await controllerDiets.retrieveDietForUser();

                      if(userDiet.isEmpty&&context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Se necesita un nutricionista asignado primero"),)
                        );
                      }
                      else if (context.mounted){
                        User? user = auth.getCurrentUser();
                        String userUid = user!.uid;
                        String profId = userDiet['professional'];

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  ChatPage(currentUser: userUid, otherUser: profId)),
                        );
                      }
                    },
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_alert_sharp, size: 80,),
                          Text("Mensajes", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,))
                        ]
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>   Tracker(gender: _gender,)),
                      );
                    },
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_chart_sharp, size: 80,),
                          Text('Tu progreso', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,))
                        ]
                    ),
                  ),

                ]
        )
        )
    );
  }
}