import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/pages/application_professional.dart';
import 'package:happ_eats/pages/dictionary.dart';
import 'package:happ_eats/pages/show_patients.dart';
import 'package:happ_eats/pages/user_recipes.dart';

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
import '../utils/loading_dialog.dart';
import 'options_professional.dart';

/// View for displaying the options of the professional menu, and the user name
class MenuProfessional extends StatefulWidget {
  const MenuProfessional({super.key});

  @override
  State<MenuProfessional> createState() => _MenuProfessionalState();
}

class _MenuProfessionalState extends State<MenuProfessional> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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

  late String _displayName = "";

  late String _gender = "";

  @override
  void initState() {

    getNameInitialized();

    super.initState();
  }

  void getNameInitialized() async {
    UserModel? result = await _controllerUsers.getUserDataFuture();
    if(result!=null)
    {
      setState(() {
        _displayName = "${result.firstName} ${result.lastName}";
        _gender = result.gender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        key : _key,
        appBar: AppBar(
          title: const Text("Happ-eats"),
            leading: IconButton(
                icon: const Icon(Icons.home_sharp),
                tooltip: 'Icono home',
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
              ),
          actions: const [
            Padding(padding:  EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Image(
                    image:AssetImage("assets/images/logo.png"),
                  ),
                ),
              ),
            )
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
                      MaterialPageRoute(builder: (context) =>  const OptionsProfessional())
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
                  _controllerUsers.logoutUser();
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
                padding: const EdgeInsets.only(right: 10.0, left: 10.0, top:10.0, bottom:10.0),
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