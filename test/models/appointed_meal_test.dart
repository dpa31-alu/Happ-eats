import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/models/appointed_meal.dart';
import 'package:flutter_test/flutter_test.dart';



void main()  {


  group('Test Appointed Meal Repository', ()   {

    test('Appointed meals for today retrieves the correct amount of appointments', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      AppointedMealRepository repository = AppointedMealRepository(db: firestore);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      for(int i = 0; i < 21; i++) {
        await firestore.collection('appointedMeals').doc().set({'patient': uid,'appointedDate': focusedDay, 'followedCorrectly':true});
      }
      DateTime date = DateTime.now();
      await firestore.collection('appointedMeals').doc().set({'patient': uid,'appointedDate': date, 'followedCorrectly':true});

      repository.getAllAppointmentsForToday(focusedDay, uid).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 21);
      }));

    });

    test('Appointed meals retrieves the correct amount of appointments', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      AppointedMealRepository repository = AppointedMealRepository(db: firestore);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      DateTime focusedDay2 = DateTime.utc(DateTime.now().year, DateTime.now().month-1, DateTime.now().day);

      DateTime fakeDay = DateTime.utc(DateTime.now().year-1, DateTime.now().month, DateTime.now().day);

      for(int i = 0; i < 21; i++) {
        await firestore.collection('appointedMeals').doc().set({'diet': uid, 'patient': uid, 'professional': uid,'appointedDate': focusedDay, 'followedCorrectly':true});
      }
      for(int i = 0; i < 21; i++) {
        await firestore.collection('appointedMeals').doc().set({'diet': uid, 'patient': uid, 'professional': uid, 'appointedDate': fakeDay, 'followedCorrectly':true});
      }

      repository.getAllAppointmentsStream(focusedDay2, focusedDay, uid, uid).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 21);
      }));

    });

    test('Appointed meal creation batch added correctly', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      AppointedMealRepository repository = AppointedMealRepository(db: firestore);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      WriteBatch batch = firestore.batch();
      batch = await repository.createAppointedMeal(batch, uid, uid, uid, uid, focusedDay, uid, 'dishName', 1,
          {});
      await batch.commit();

      DocumentSnapshot<Map<String, dynamic>> a = await firestore.collection('appointedMeals').doc(uid).get();
      expect(a.data(), {
      'alternativeRequired': false,
      'diet': uid,
      'professional': uid,
      'patient': uid,
      'appointedDate': Timestamp.fromDate(focusedDay),
      'dish': uid,
      'dishName': 'dishName',
      'values': {},
      'mealOrder': 1
      });
    });

    test('Appointed meal issues batch added correctly', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      AppointedMealRepository repository = AppointedMealRepository(db: firestore);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);


      firestore.collection('appointedMeals').doc(uid).set({
        'alternativeRequired': false,
        'diet': uid,
        'professional': uid,
        'patient': uid,
        'appointedDate': Timestamp.fromDate(focusedDay),
        'dish': uid,
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1
      });

      WriteBatch batch = firestore.batch();
      batch = await repository.signalIssuesAppointedMeal(batch, uid, 'note');
      await batch.commit();

      DocumentSnapshot<Map<String, dynamic>> a = await firestore.collection('appointedMeals').doc(uid).get();
      expect(a.data(), {
        'alternativeRequired': true,
        'diet': uid,
        'professional': uid,
        'patient': uid,
        'appointedDate': Timestamp.fromDate(focusedDay),
        'dish': uid,
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1,
        'note':'note'
      });

    });

    test('Appointed meal confirmation batch added correctly', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      AppointedMealRepository repository = AppointedMealRepository(db: firestore);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);


      firestore.collection('appointedMeals').doc(uid).set({
        'alternativeRequired': false,
        'diet': uid,
        'professional': uid,
        'patient': uid,
        'appointedDate': Timestamp.fromDate(focusedDay),
        'dish': uid,
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1
      });

      WriteBatch batch = firestore.batch();
      batch = await repository.consumedCorrectlyAppointedMeal(batch, uid);
      await batch.commit();

      DocumentSnapshot<Map<String, dynamic>> a = await firestore.collection('appointedMeals').doc(uid).get();
      expect(a.data(), {
        'alternativeRequired': false,
        'diet': uid,
        'professional': uid,
        'patient': uid,
        'appointedDate': Timestamp.fromDate(focusedDay),
        'dish': uid,
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1,
        'followedCorrectly':true
      });

    });

    test('All appointed meal deletion batch added correctly', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      AppointedMealRepository repository = AppointedMealRepository(db: firestore);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);


      for(int i = 0; i < 21; i++) {
       await firestore.collection('appointedMeals').doc().set({'patient': uid,'appointedDate': focusedDay, 'followedCorrectly':true});
      }


      WriteBatch batch = firestore.batch();
      batch = await repository.deleteAllUserMeals(batch, uid);
      await batch.commit();

      QuerySnapshot<Map<String, dynamic>> a = await firestore.collection('appointedMeals').get();
      expect(a.docs.length, 0);

    });

  });
}