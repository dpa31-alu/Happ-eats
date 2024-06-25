
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/dish_controller.dart';
import 'package:happ_eats/utils/loading_dialog.dart';

import '../controllers/user_controller.dart';
import '../models/dish.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/file_service.dart';

class ShowRecipe extends StatelessWidget {
  final Map<String, dynamic> dishValues;
  final Map<String, dynamic> dishIngredients;
  final String dishName;
  final String dishInstructions;
  final String? dishImage;
  final String dishUser;
  final String dishID;

   const ShowRecipe({super.key, required this.dishValues, required this.dishIngredients,
    required this.dishName, required this.dishInstructions, required this.dishImage, required this.dishUser, required this.dishID,});

  @override
  Widget build(BuildContext context) {

    final UsersController controllerUser = UsersController(db: FirebaseFirestore.instance, auth: AuthService(auth: FirebaseAuth.instance,));
    final DishesController controllerDishes = DishesController(db: FirebaseFirestore.instance,
        auth: AuthService(auth: FirebaseAuth.instance,),
        file: FileService(storage: FirebaseStorage.instance, auth: AuthService(auth: FirebaseAuth.instance,)),
        repositoryUser: UserRepository(db: FirebaseFirestore.instance),
        repositoryDish: DishRepository(db: FirebaseFirestore.instance));

    final List<String> valuesOrder = ['Calorías (kcal)',
      'Proteínas (g)',
      'Lípidos totales (g)',
      'AG saturados (g)',
      'AG monoinsaturados (g)',
      'AG poliinsaturados (g)',
      'Omega-3 (g)',
      'C18:2 Linoleico (omega-6) (g)',
      'Colesterol (mg/1000 kcal)',
      'Hidratos de carbono (g)',
      'Fibra (g)',
      'Agua (g)',

      'Calcio (mg)',
      'Hierro (mg)',
      'Yodo (µg)',
      'Magnesio (mg)',
      'Zinc (mg)',
      'Sodio (mg)',
      'Potasio (mg)',
      'Fósforo (mg)',
      'Selenio (μg)',

      'Tiamina (mg)',
      'Riboflavina (mg)',
      'Equivalentes niacina (mg)',
      'Vitamina B6 (mg)',
      'Folatos (μg)',
      'Vitamina B12 (μg)',
      'Vitamina C (mg)',
      'Vitamina A: Eq. Retinol (μg)',
      'Vitamina D (μg)',
      'Vitamina E (mg)',
      'trazas'];

    final size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
       appBar: AppBar(
         //leading: Icon(Icons.account_circle_rounded),
          title: const Text("Happ-eats"),
           actions: (controllerUser.getCurrentUserUid()==dishUser)? <Widget>[
             IconButton(
               icon: const Icon(Icons.delete_forever_sharp),
               tooltip: 'Delete Dish',
               onPressed: () async {
                 showDialog(context: context, builder: (BuildContext context) {
                   return AlertDialog(
                     title: const Text("Confirmación"),
                     content: const Text("¿Desea borrar este plato?"),
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

                           String? result = await controllerDishes.deleteDish(dishID, dishUser, dishImage);

                           if(context.mounted) {
                             Navigator.pop(context);
                           }

                           if(result!=null&&context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text("Error en el borrado")),
                             );
                           }

                           if(context.mounted) {
                             Navigator.pop(context);
                           }

                           if(result==null&&context.mounted)
                             {
                               if(context.mounted) {
                               Navigator.pop(context);
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
             ),
           ] : <Widget>[
             IconButton(
               icon: const Icon(Icons.copy_sharp),
               tooltip: 'Copy Dish',
               onPressed: () async {
                 showDialog(context: context, builder: (BuildContext context) {
                   return AlertDialog(
                     title: const Text("Confirmación"),
                     content: const Text("¿Desea copiar este plato?"),
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
                           String? result = await controllerDishes.copyDish(dishName, dishInstructions, dishValues, dishIngredients);

                           if(context.mounted) {
                             Navigator.pop(context);
                           }

                           if(result!=null&&context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text("Error en la copia")),
                             );
                           }

                           if(result==null&&context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text("Copia realizada correctamente")),
                             );
                           }

                           if(context.mounted) {
                             Navigator.pop(context);
                           }

                         },
                         child: const Text('Aceptar'),
                       ),
                     ],
                   );
                 }
                 );
               },
             ),
           ]
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    height:size.height*0.4,
                    width: size.width,

                    decoration: (dishImage!=null) ? BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(dishImage!),
                        fit: BoxFit.cover,
                      ),
                    ) : const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      ),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.5,
                        ),
                        SizedBox(
                          width: size.width * 0.5,
                            child:  Container(padding: const EdgeInsets.only(right: 10.0,),
                              child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                dishName,

                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    shadows: [
                                      Shadow( // bottomLeft
                                          offset: Offset(-1.5, -1.5),
                                          color: Colors.black
                                      ),
                                      Shadow( // bottomRight
                                          offset: Offset(1.5, -1.5),
                                          color: Colors.black
                                      ),
                                      Shadow( // topRight
                                          offset: Offset(1.5, 1.5),
                                          color: Colors.black
                                      ),
                                      Shadow( // topLeft
                                          offset: Offset(-1.5, 1.5),
                                          color: Colors.black
                                      ),
                                    ],
                                    color: Colors.white,
                                    fontSize: 40
                                ),
                              ),
                            ))
                        ),

                      ],
                    ),
                  ),

                  const Divider(),



                  Card(
                    child: Column(
                      children: [
                        const Text("Ingredientes", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),),
                        ListView.builder(
                          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dishIngredients.length,
                          itemBuilder: (context, index) {
                            String key = dishIngredients.keys.elementAt(index);
                            return ListTile(
                              title: Text(key),
                              subtitle: Text(dishIngredients[key]),
                            );
                          },
                        ),
                      ],
                    )
                  ),

                  const Divider(),



                  Card(
                      child: Column(
                        children: [
                          const Text("Valor Nutricional", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),),
                          ListView.builder(
                            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dishValues.length-1,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(valuesOrder[index]),
                                subtitle: Text(dishValues[valuesOrder[index]].toString()),
                              );
                            },
                          ),
                        ],
                      )
                  ),

                  const Divider(),

                  Card(
                      child: Column(
                        children: [
                          const Text("Preparación", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),),
                          Container(
                            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                            child:  Align(
                              alignment: Alignment.topLeft,
                              child: Text(dishInstructions),
                            ),
                          ),
                        ],
                      )
                  )
                ],
              ),
        )
        )
    );
  }


}