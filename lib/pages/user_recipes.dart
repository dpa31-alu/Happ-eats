import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/pages/recipe.dart';

import '../controllers/dish_controller.dart';
import '../models/dish.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/file_service.dart';

/// View for displaying all of a user's recipes
class UserRecipes extends StatefulWidget {
  const UserRecipes({super.key});

  @override
  State<UserRecipes> createState() => _UserRecipesState();
}

class _UserRecipesState extends State<UserRecipes> {

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

  final DishesController _controllerDishes = DishesController(db: FirebaseFirestore.instance,
      auth: AuthService(auth: FirebaseAuth.instance,),
      file: FileService(storage: FirebaseStorage.instance, auth: AuthService(auth: FirebaseAuth.instance,)),
      repositoryUser: UserRepository(db: FirebaseFirestore.instance),
      repositoryDish: DishRepository(db: FirebaseFirestore.instance));

  @override
  Widget build(BuildContext context) {


    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Text("Happ-eats"),
        ),
        body: SafeArea(
          child:  StreamBuilder(
            stream: _controllerDishes.retrieveAllDishesForUser(_amount),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  const Center( child:CircularProgressIndicator());
            }
            else if (snapshot.hasError) {
              return  const Center(child: Text("No se han podido recuperar los platos"),);
            }
            else if (!snapshot.hasData||snapshot.data.docs.length == 0) {
              return  const Center( child: Text("No hay platos registrados"),);
            }
            else {
              return GridView.builder(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {

                  return Container(decoration: (snapshot.data.docs[index]['image'] != null) ?  BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(snapshot.data.docs[index]['image']),
                      fit: BoxFit.cover,
                    ),
                  ) :
                      const BoxDecoration(

                        color: Colors.lightBlueAccent,
                      ),
                      child: TextButton(

                          style: ElevatedButton.styleFrom(

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowRecipe(dishValues: snapshot.data.docs[index]['nutritionalInfo'], dishIngredients: snapshot.data.docs[index]['ingredients'], dishName: snapshot.data.docs[index]['name'], dishInstructions: snapshot.data.docs[index]['description'], dishImage: snapshot.data.docs[index]['image'], dishUser: snapshot.data.docs[index]['user'], dishID: snapshot.data.docs[index].id,),),
                          );},
                          child: SizedBox(
                              width: size.width * 0.5,
                              child:  Align(
                                alignment: Alignment.center,
                                child: Text(
                                  snapshot.data.docs[index]['name'],
                                  textAlign: TextAlign.center,
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
                                      fontSize: 20
                                  ),),
                              )
                          )
                      )
                  );
                },
              );
            }
          }
        )
    )
    );
  }
}