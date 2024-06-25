import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/pages/application_professional.dart';
import 'package:happ_eats/pages/dictionary.dart';
import 'package:happ_eats/pages/show_patients.dart';
import 'package:happ_eats/pages/user_recipes.dart';

import '../controllers/ingredient_controller.dart';
import '../controllers/user_controller.dart';
import '../services/auth_service.dart';
import '../utils/loading_dialog.dart';
import 'options_professional.dart';

class MenuProfessional extends StatefulWidget {
  const MenuProfessional({super.key});

  @override
  State<MenuProfessional> createState() => _MenuProfessionalState();
}

class _MenuProfessionalState extends State<MenuProfessional> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final UsersController controllerUser = UsersController(db: FirebaseFirestore.instance, auth: AuthService(auth: FirebaseAuth.instance,));

  late String _displayName = "";

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
        _gender = "${result['gender']}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        key : _key,
        appBar: AppBar(
          title: const Text("Happ-eats - Professional"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home_sharp),
                tooltip: 'Icono home',
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
              ),
            ]
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
                      MaterialPageRoute(builder: (context) =>  OptionsProfessional())
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShowPatients()),
                      );
                    },
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.accessibility_new_sharp, size: 80,),
                          Text("Pacientes", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,))
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
                        MaterialPageRoute(builder: (context) => const ApplicationProfessional()),
                      );
                    },
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_tree_sharp, size: 80,),
                          Text("Solicitudes", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,))
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

                  /*ElevatedButton(onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, elevation:2), child: const Text("logout", style: TextStyle(color: Colors.white, fontSize: 16),)),*/

                ]
            )
        )
    );
  }
}