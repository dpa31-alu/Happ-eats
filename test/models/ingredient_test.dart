import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/models/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:mock_exceptions/mock_exceptions.dart';

void main()  {


  group('Test Ingredient Repository', ()   {


    test('Ingredient can be retrieved', () async {

      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;

      IngredientRepository repository = IngredientRepository(db: firestore);

      Map<String, dynamic> ingredients = {'ingredients': {}};

      firestore.collection('ingredients').doc().set(ingredients);

      QuerySnapshot<Map<String, dynamic>> ingredientsRetrieved = await repository.getAllIngredients();

      expect(ingredientsRetrieved.docs.length, 1);

    });

    test('Ingredient retrieval can cause exception', () async {

      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;

      IngredientRepository repository = IngredientRepository(db: firestore);

      Map<String, dynamic> ingredients = {'ingredients': {}};

      firestore.collection('ingredients').doc().set(ingredients);

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('ingredients').doc())
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));

      expect(() => repository.getAllIngredients(), throwsException);

    });

  });
}