import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/pages/menu_patient.dart';
import 'package:happ_eats/pages/menu_professional.dart';
import 'package:happ_eats/pages/welcome_page.dart';
import 'package:happ_eats/services/auth_service.dart';

import '../controllers/user_controller.dart';

class RedirectLogin extends StatelessWidget {
  const RedirectLogin({super.key});


  @override
  Widget build(BuildContext context) {

    AuthService auth =  AuthService(auth: FirebaseAuth.instance,);

    final UsersController controllerUser = UsersController(db: FirebaseFirestore.instance, auth: auth);

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
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  else if (snapshot.hasError) {
                    return const WelcomePage();
                  }
                  else if (!snapshot2.hasData) {
                    return const CircularProgressIndicator();
                  }
                  else if (snapshot2.data == true) {
                    /*Navigator.pushReplacement(context,  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const MenuPatient(),
                    ),);*/
                    return  const MenuPatient();
                  }
                  else {
                   /* Navigator.pushReplacement(context,  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const MenuProfessional(),
                    ),);*/
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
