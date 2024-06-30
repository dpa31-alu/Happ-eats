import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/controllers/ingredient_controller.dart';
import 'package:happ_eats/models/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ingredient_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IngredientRepository>()])


void main()  {



  group('Test Ingredient Controller', ()   {


    test('retrieveAllIngredients catches exception and returns null', () async {

      final ingredientRepository = MockIngredientRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');

      IngredientsController controller = IngredientsController(db: firestore, repositoryIngredient: ingredientRepository);

      when(ingredientRepository.getAllIngredients()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      expect(await controller.retrieveAllIngredients() , null);

      /*Map<String, dynamic> ingredients = {'ingredients': {}};

      firestore.collection('ingredients').doc().set(ingredients);

      QuerySnapshot<Map<String, dynamic>> ingredientsRetrieved = await repository.getAllIngredients();

      expect(ingredientsRetrieved.docs.length, 1);*/

    });

    test('retrieveAllIngredients catches exception and returns null', () async {

      final ingredientRepository = MockIngredientRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');

      IngredientsController controller = IngredientsController(db: firestore, repositoryIngredient: ingredientRepository);

      firestore.collection('ingredients').doc().set({'ingredients': [{'nombre':'patata'},{'nombre':'huevo'}] });

      when(ingredientRepository.getAllIngredients()).thenAnswer((realInvocation) => firestore.collection('ingredients').get());

      expect(await controller.retrieveAllIngredients() , [{'nombre':'patata'},{'nombre':'huevo'}]);

    });

  });

}