import 'package:flutter/material.dart';
import 'package:happ_eats/pages/login.dart';
import 'package:happ_eats/pages/sign_up_selector.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
    backgroundColor: Colors.orangeAccent,
      body: SafeArea(
        child: SingleChildScrollView (
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* Center(
                  child: Image.asset('assets/images/logo_welcome.png'),
              ),*/
                const SizedBox(height: 350),
                const Center(
                    child: Text('Happ-eats', style: TextStyle(fontSize: 50.0, color: Colors.black, fontWeight: FontWeight.bold,),)
                ),
                Center(
                  child: Container(
                    width: size.width * 0.7,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: const Center(
                        child: Text("Nutrición y alimentación", style: TextStyle(fontSize: 18, color: Colors.white),)
                    ),
                  ),
                ),
                const SizedBox(height: 200),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpSelector()),
                  );
                }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, elevation:2), child: const Text("Empieza ahora", style: TextStyle(color: Colors.white, fontSize: 16),)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿Ya tienes una cuenta?", style: TextStyle(color: Colors.black, fontSize: 14),),
                    TextButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    }, child: const Text("Inicia sesión", style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 14))),
                  ],
                ),
              ]
          ),
        )
      ),
    );
  }
}

