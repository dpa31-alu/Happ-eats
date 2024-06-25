import 'package:flutter/material.dart';
import 'package:happ_eats/pages/sign_up_patient.dart';
import 'package:happ_eats/pages/sign_up_professional.dart';

class SignUpSelector extends StatelessWidget {
  const SignUpSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.small(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        body: SafeArea(
            child: Stack(
              children:
              [
                Positioned(
                  top: size.height * 0.6,
                  left: size.width * 0.05,
                  child:  Container(
                    height: size.height * 0.6,
                    width: size.width * 1.2,
                    decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.20,
                  left: size.width * 0.25,
                  child:  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.70,
                    decoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * -0.1,
                  left: size.width * -0.30,
                  child:  Container(
                    height: size.height * 0.3,
                    width: size.width * 0.55,
                    decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle
                    ),
                  ),
                ),


                /*ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, style: ElevatedButton.styleFrom(elevation:2,), child: const Icon(
                  Icons.arrow_back_ios_new_rounded, size: 25,)
                ),*/



                Center(
                    child: SingleChildScrollView(
                      child: Column(
                          children: [
                            const Text("¿Qué eres?", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,),),
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.accessibility_new_sharp,

                                size: 30.0,
                              ),
                              label: const Text('Paciente'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpPatient()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.account_balance_sharp,
                                size: 30.0,
                              ),
                              label: const Text('Profesional'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpProfessional()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            )
                          ],

                      )
                    )
                ),
              ],
            )
        )
    );
  }


}