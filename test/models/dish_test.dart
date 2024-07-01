import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:happ_eats/models/dish.dart';

import 'package:flutter_test/flutter_test.dart';


import 'package:mock_exceptions/mock_exceptions.dart';

void main()  {


  group('Test Dish Repository', ()   {

    test('Dishes for amount retrieves the correct amount of dishes', () async {
      MockFirebaseAuth auth0 = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth0.authForFakeFirestore);
      await auth0.signInWithCustomToken('some token');
      final uid = auth0.currentUser!.uid;
      DishRepository repository = DishRepository(db: firestore);

      for(int i = 0; i < 21; i++) {
        firestore.collection('dishes').doc().set({'user' : uid, 'name': 'torrezno'});
        firestore.collection('dishes').doc().set({'user' : 'otrouid', 'name': 'torrezno'});
      }

      repository.getAllDishes(20, uid).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 20);
      }));
    });

    test('Dish creation added to batch correctly', () async {
      MockFirebaseAuth auth0 = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth0.authForFakeFirestore);
      await auth0.signInWithCustomToken('some token');
      DishRepository repository = DishRepository(db: firestore);


      String id = firestore.collection('dishes').doc().id;

      WriteBatch batch = firestore.batch();
      batch = await repository.createDish(batch, id, 'user', 'dishName', 'description', {}, null, {});
      batch.commit();
      DocumentSnapshot<Map<String, dynamic>> a = await firestore.collection('dishes').doc(id).get();
      expect(a.data(), {
        'user': 'user',
        'name': 'dishName',
        'description': 'description',
        'image': null,
        'nutritionalInfo': {},
        'ingredients': {}
      });

    });

    test('Dish deletion adds tasks to batch correctly', () async {
      MockFirebaseAuth auth0 = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth0.authForFakeFirestore);
      await auth0.signInWithCustomToken('some token');
      DishRepository repository = DishRepository(db: firestore);
      String id = firestore.collection('dishes').doc().id;

      firestore.collection('dishes').doc(id).set({
        'user': 'user',
        'name': 'dishName',
        'description': 'description',
        'image': null,
        'nutritionalInfo': {},
        'ingredients': {}
      });
      DocumentSnapshot<Map<String, dynamic>> test = await firestore.collection('dishes').doc(id).get();
      expect(test.data(), {
        'user': 'user',
        'name': 'dishName',
        'description': 'description',
        'image': null,
        'nutritionalInfo': {},
        'ingredients': {}
      });

      WriteBatch batch = firestore.batch();
      batch = await repository.deleteDish(batch, id);
      batch.commit();

      DocumentSnapshot<Map<String, dynamic>> a = await firestore.collection('dishes').doc(id).get();
      expect(a.data(), null);

    });

    test('Dish retrieval is correct', () async {
      MockFirebaseAuth auth0 = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth0.authForFakeFirestore);
      await auth0.signInWithCustomToken('some token');
      DishRepository repository = DishRepository(db: firestore);

      String id = firestore.collection('dishes').doc().id;
      firestore.collection('dishes').doc(id).set({
        'user': 'user',
        'name': 'dishName',
        'description': 'description',
        'image': null,
        'nutritionalInfo': {},
        'ingredients': {}
      });

      DocumentSnapshot<Map<String, dynamic>> a = await repository.getDish(id);
      expect(a.data(), {
        'user': 'user',
        'name': 'dishName',
        'description': 'description',
        'image': null,
        'nutritionalInfo': {},
        'ingredients': {}
      });

    });

    test('Dish retrieval cam throw exception', () async {
      MockFirebaseAuth auth0 = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth0.authForFakeFirestore);
      await auth0.signInWithCustomToken('some token');
      DishRepository repository = DishRepository(db: firestore);

      String id = firestore.collection('dishes').doc().id;
      firestore.collection('dishes').doc(id).set({
        'user': 'user',
        'name': 'dishName',
        'description': 'description',
        'image': null,
        'nutritionalInfo': {},
        'ingredients': {}
      });

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('dishes').doc(id))
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));

      expect(repository.getDish(id), throwsException);

    });

    test('Dish future retrieval is correct', () async {
      MockFirebaseAuth auth0 = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth0.authForFakeFirestore);
      await auth0.signInWithCustomToken('some token');
      final uid = auth0.currentUser!.uid;
      DishRepository repository = DishRepository(db: firestore);

      for(int i = 0; i < 21; i++) {
        firestore.collection('dishes').doc().set({'user' : uid, 'name': 'torrezno'});
      }

      QuerySnapshot<Object?> a = await repository.getAllDishesFuture(uid);
      expect(a.docs.length, 21);

    });

    test('Dish future retrieval can throw exception', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final id = auth.currentUser!.uid;
      DishRepository repository = DishRepository(db: firestore);

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('dishes').doc())
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));

      expect(() => repository.getAllDishesFuture(id), throwsException);

      //expect(() => repository.getAllDishesFuture(id), throwsException);

    });

  });
}