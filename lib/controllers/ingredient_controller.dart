import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happ_eats/models/ingredient.dart';


class IngredientsController {

  final FirebaseFirestore db;

  final IngredientRepository repositoryIngredient;

  IngredientsController({required this.db, required this.repositoryIngredient});

  /// Retrieves all the ingredients from the database
  /// Modifies them to be manageable
  /// Returns a list with the data, or null
  Future<List<Map<String, dynamic>>?> retrieveAllIngredients()  async {
    try {
     QuerySnapshot<Map<String, dynamic>> querySnapshot = await repositoryIngredient.getAllIngredients();
     List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
     List<Map<String, dynamic>> result = [];
     QueryDocumentSnapshot<Map<String, dynamic>> docu;
     Map<String, dynamic> mapa = {};
     for (docu in documents) {
       for (mapa in docu.data()['ingredients']) {
           result.add(mapa);
         }
     }
     return result;
    }
    on FirebaseException {
      return null;
    }
  }
}