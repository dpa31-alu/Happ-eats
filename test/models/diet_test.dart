import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:mock_exceptions/mock_exceptions.dart';

void main()  {


  group('Test Diet Repository', ()   {

    test('Diet can be added to batch for creation', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      DietRepository repository = DietRepository(db: firestore);

      DateTime date = DateTime.now();

      WriteBatch batch =  firestore.batch();
      batch = await repository.createDiet(batch, uid, uid, 'newFirstName', 'newLastName', 'newGender', 'newMedicalCondition', 100.0, 100.0, date, 'newObjectives', 'newType');
      await batch.commit();

      QuerySnapshot<Map<String, dynamic>> p = await firestore.collection('diets').where('patient', isEqualTo: uid).get();
      expect(p.docs[0].data()['patient'], uid);

    });


    test('Diet can be added to batch for deletion', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'gender': 'M',});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'gender': 'M',});
      WriteBatch batch = firestore.batch();

      batch = await repository.deleteDiet(batch, uid);

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), null);

    });


    test('Diet can be added to batch for updating firstName', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'firstName': 'firstName',});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'firstName': 'firstName',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateDietFirstName(batch, uid, 'firstNameTest');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), {'firstName': 'firstNameTest',});

    });


    test('Diet can be added to batch for updating lastName', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'lastName': 'lastName',});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'lastName': 'lastName',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateDietLastName(batch, uid, 'lastNameTest');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), {'lastName': 'lastNameTest',});

    });



    test('Diet can be added to batch for updating gender', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'gender': 'F',});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'gender': 'F',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateDietGender(batch, uid, 'M');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), {'gender': 'M',});

    });



    test('Diet can be added to batch for updating medical conditions', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'medicalCondition': 'bien',});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'medicalCondition': 'bien',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateDietMedicalCondition(batch, uid, 'mal');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), {'medicalCondition': 'mal',});

    });



    test('Diet can be added to batch for updating weight', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'weight': 100,});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'weight': 100,});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateDietWeight(batch, uid, '200');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), {'weight': 200,});

    });



    test('Diet can be added to batch for updating height', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'height': 100,});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'height': 100,});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateDietHeight(batch, uid, '200');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), {'height': 200,});

    });



    test('Diet can be added to batch for updating birthday', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      DateTime date = DateTime.now();

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'birthday': date,});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'birthday': Timestamp.fromDate(date),});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateDietBirthday(batch, uid, date.toString());

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), {'birthday': Timestamp.fromDate(date),});

    });



    test('Diet can be added to batch for adding reference to a document', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);


      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

      firestore.collection('diets').doc(uid).set({'url': 'http',});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(), {'url': 'http',});
      WriteBatch batch = firestore.batch();

      batch = await repository.addRefApplication(batch, uid, 'https');
      batch.commit();

      DocumentSnapshot doc = await firestore.collection('diets').doc(uid).get();
      expect(doc.data(), {'url': 'https',});

    });


    test('Diet can return empty map', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);

/*
      String id = "0212151512";

      Map<String, dynamic> m = {'gender': 'newGender', 'medicalCondition': 'newMedicalCondition', 'weight': 100, 'startingWeight' : 100,  'height': 100,  'birthday': Timestamp.fromDate(date)};

      firestore.collection('diets').doc(uid).set({});
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(),  {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100,
        'startingWeight': 100,
        'height': 100,
        'birthday': Timestamp.fromDate(date)
      });*/

      Map<String, dynamic> user = await repository.getDietForUser(uid);

      expect(user, {});

    });



    test('Diet can be retrieved', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);


      DateTime time = DateTime.timestamp();


      Map<String, dynamic> m = {'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': time,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': time};

      firestore.collection('diets').doc(uid).set(m);
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(),  {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': Timestamp.fromDate(time),
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': Timestamp.fromDate(time),
      });


      Map<String, dynamic> user = await repository.getDietForUser(uid);

      expect(user, {
        'uid': uid,
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': time.toLocal(),
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': Timestamp.fromDate(time),
        'url':null
      });

    });


    test('Diet retrieval can cause exception', () async {


      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      DietRepository repository = DietRepository(db: firestore);


      DateTime time = DateTime.timestamp();


      Map<String, dynamic> m = {'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': time,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': time};

      firestore.collection('diets').doc(uid).set(m);
      DocumentSnapshot test = await firestore.collection('diets').doc(uid).get();
      expect(test.data(),  {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': Timestamp.fromDate(time),
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': Timestamp.fromDate(time),
      });

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('diets').doc())
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));



      expect(()=> repository.getDietForUser(uid), throwsException);

    });

    test('Get all diets returns the correct amount of diets for the correct professional', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      DietRepository repository = DietRepository(db: firestore);

      DateTime time = DateTime.timestamp();

      for(int i = 0; i < 21; i++) {
        await firestore.collection('diets').doc().set({'patient': uid,
          'professional': uid,
          'firstName': 'newFirstName',
          'lastName':'newLastName',
          'gender': 'newGender',
          'medicalCondition': 'newMedicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': time,
          'objectives': 'newObjectives',
          'type': 'Peso',
          'date': time});
        await firestore.collection('diets').doc().set({'patient': uid,
          'professional': 'uid',
          'firstName': 'newFirstName',
          'lastName':'newLastName',
          'gender': 'newGender',
          'medicalCondition': 'newMedicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': time,
          'objectives': 'newObjectives',
          'type': 'Patología',
          'date': time});
      }

      //print(firestore.dump());

      repository.getAllDiets('Peso', 21, uid).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 21);
        expect(snap.docChanges.first.doc.data()!['type'], 'Peso');
      }));

    });

    test('Get all diets returns the correct amount of diets for the correct professional', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      DietRepository repository = DietRepository(db: firestore);

      DateTime time = DateTime.timestamp();

      for(int i = 0; i < 21; i++) {
        await firestore.collection('diets').doc().set({'patient': uid,
          'professional': uid,
          'firstName': 'newFirstName',
          'lastName':'newLastName',
          'gender': 'newGender',
          'medicalCondition': 'newMedicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': time,
          'objectives': 'newObjectives',
          'type': 'Peso',
          'date': time});
        await firestore.collection('diets').doc().set({'patient': uid,
          'professional': 'uid',
          'firstName': 'newFirstName',
          'lastName':'newLastName',
          'gender': 'newGender',
          'medicalCondition': 'newMedicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': time,
          'objectives': 'newObjectives',
          'type': 'Patología',
          'date': time});
      }

      //print(firestore.dump());

      QuerySnapshot<Map<String, dynamic>> test = await repository.getAllDietsForProfessional(uid);

      expect(test.docs.length, 21);

    });

    test('Get all diets returns error code', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      DietRepository repository = DietRepository(db: firestore);

      DateTime time = DateTime.timestamp();

      for(int i = 0; i < 21; i++) {
        await firestore.collection('diets').doc().set({'patient': uid,
          'professional': uid,
          'firstName': 'newFirstName',
          'lastName':'newLastName',
          'gender': 'newGender',
          'medicalCondition': 'newMedicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': time,
          'objectives': 'newObjectives',
          'type': 'Peso',
          'date': time});
        await firestore.collection('diets').doc().set({'patient': uid,
          'professional': 'uid',
          'firstName': 'newFirstName',
          'lastName':'newLastName',
          'gender': 'newGender',
          'medicalCondition': 'newMedicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': time,
          'objectives': 'newObjectives',
          'type': 'Patología',
          'date': time});
      }

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('diets').doc())
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));

      expect(() =>  repository.getAllDietsForProfessional(uid), throwsException);

    });



  });
}