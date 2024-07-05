import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/appointed_meal.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:happ_eats/models/dish.dart';
import 'package:happ_eats/models/message.dart';
import 'package:happ_eats/models/patient.dart';
import 'package:happ_eats/models/user.dart';
import 'package:happ_eats/pages/menu_patient.dart';
import 'package:happ_eats/pages/menu_professional.dart';
import 'package:happ_eats/pages/welcome_page.dart';
import 'package:happ_eats/services/auth_service.dart';

import '../controllers/user_controller.dart';
import '../models/professional.dart';

/// View for controlling the redirection on login to both menus
class RedirectLogin extends StatelessWidget {
  const RedirectLogin({super.key});


  @override
  Widget build(BuildContext context) {

    AuthService auth =  AuthService(auth: FirebaseAuth.instance,);

    final UsersController controllerUser = UsersController(
        db: FirebaseFirestore.instance,
        auth: auth,
        repositoryUser: UserRepository(db: FirebaseFirestore.instance),
        repositoryProfessional: ProfessionalRepository(db: FirebaseFirestore.instance),
        repositoryMessages: MessageRepository(db: FirebaseFirestore.instance),
        repositoryPatient: PatientRepository(db: FirebaseFirestore.instance),
        repositoryDish: DishRepository(db: FirebaseFirestore.instance),
        repositoryAppointedMeal: AppointedMealRepository(db: FirebaseFirestore.instance),
        repositoryApplication: ApplicationRepository(db: FirebaseFirestore.instance),
        repositoryDiets: DietRepository(db: FirebaseFirestore.instance),);

    return Scaffold(
      body: StreamBuilder(
        stream: auth.authStateChangesStream(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const WelcomePage();
          }
          else if (snapshot.hasError) {
            return const WelcomePage();
          }
          else {
                return StreamBuilder <bool>(
                stream:  controllerUser.isPatient(snapshot.data.uid),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.waiting)
                    {
                      return const SafeArea(child: Center(child: CircularProgressIndicator(),));
                    }
                  else if (snapshot.hasError) {
                    return const WelcomePage();
                  }
                  else if (!snapshot2.hasData) {
                    return  const SafeArea(child: Center(child: CircularProgressIndicator(),));
                  }
                  else if (snapshot2.data == true) {

                    return  const MenuPatient();
                  }
                  else {

                    return const MenuProfessional();
                  }

                 }
              );
          }

        }
      )
    );
  }
}
