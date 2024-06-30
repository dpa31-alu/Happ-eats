import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/models/patient.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:mock_exceptions/mock_exceptions.dart';

void main()  {


  group('Test Patient Repository', ()   {

    test('Patient can be added to batch for creation', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      PatientRepository repository = PatientRepository(db: firestore);

      DateTime date = DateTime.now();

      WriteBatch batch =  firestore.batch();
      batch = await repository.createPatient(batch, uid, 'newGender', 'newMedicalCondition', '100', '100', date.toString());
      await batch.commit();

      DocumentSnapshot p = await firestore.doc('patients/$uid').get();
      Map<String, dynamic> m = {'gender': 'newGender', 'medicalCondition': 'newMedicalCondition', 'weight': 100, 'startingWeight' : 100,  'height': 100,  'birthday': Timestamp.fromDate(date)};
      expect(p.data(), equals(m));
    });

    test('Patient can be added to batch for deletion', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      firestore.collection('patients').doc(uid).set({'gender': 'M',});
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(), {'gender': 'M',});
      WriteBatch batch = firestore.batch();

      batch = await repository.deletePatient(batch, uid);

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('patients').doc(uid).get();
      expect(doc.data(), null);

    });

    test('Patient can be added to batch for updating gender', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      firestore.collection('patients').doc(uid).set({'gender': 'F',});
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(), {'gender': 'F',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updatePatientGender(batch, uid, 'M');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('patients').doc(uid).get();
      expect(doc.data(), {'gender': 'M',});

    });

    test('Patient can be added to batch for updating medical conditions', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      firestore.collection('patients').doc(uid).set({'medicalCondition': 'bien',});
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(), {'medicalCondition': 'bien',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updatePatientMedicalCondition(batch, uid, 'mal');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('patients').doc(uid).get();
      expect(doc.data(), {'medicalCondition': 'mal',});

    });

    test('Patient can be added to batch for updating weight', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      firestore.collection('patients').doc(uid).set({'weight': 100,});
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(), {'weight': 100,});
      WriteBatch batch = firestore.batch();

      batch = await repository.updatePatientWeight(batch, uid, '200');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('patients').doc(uid).get();
      expect(doc.data(), {'weight': 200,});

    });

    test('Patient can be added to batch for updating height', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      firestore.collection('patients').doc(uid).set({'height': 100,});
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(), {'height': 100,});
      WriteBatch batch = firestore.batch();

      batch = await repository.updatePatientHeight(batch, uid, '200');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('patients').doc(uid).get();
      expect(doc.data(), {'height': 200,});

    });

    test('Patient can be added to batch for updating birthday', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      DateTime date = DateTime.now();

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      firestore.collection('patients').doc(uid).set({'birthday': date,});
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(), {'birthday': Timestamp.fromDate(date),});
      WriteBatch batch = firestore.batch();

      batch = await repository.updatePatientBirthday(batch, uid, date.toString());

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('patients').doc(uid).get();
      expect(doc.data(), {'birthday': Timestamp.fromDate(date),});

    });

    test('Patient can be retrieved', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      DateTime date = DateTime.now();


      Map<String, dynamic> m = {'gender': 'newGender', 'medicalCondition': 'newMedicalCondition', 'weight': 100, 'startingWeight' : 100,  'height': 100,  'birthday': Timestamp.fromDate(date)};

      firestore.collection('patients').doc(uid).set(m);
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(),  {
      'gender': 'newGender',
      'medicalCondition': 'newMedicalCondition',
      'weight': 100,
      'startingWeight': 100,
      'height': 100,
      'birthday': Timestamp.fromDate(date)
      });

      PatientModel user = await repository.getPatient(uid);

      expect(user.toMap(), {
        'user': uid,
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100,
        'startingWeight': 100,
        'height': 100,
        'birthday': date
      });

    });

    test('Patient retrieval can cause exception', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      DateTime date = DateTime.now();


      Map<String, dynamic> m = {'gender': 'newGender', 'medicalCondition': 'newMedicalCondition', 'weight': 100, 'startingWeight' : 100,  'height': 100,  'birthday': Timestamp.fromDate(date)};

      firestore.collection('patients').doc(uid).set(m);
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(),  {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100,
        'startingWeight': 100,
        'height': 100,
        'birthday': Timestamp.fromDate(date)
      });


      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('patients').doc(uid))
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));

      expect(() => repository.getPatient(uid), throwsException);

    });

    test('Is patient can return false if user is not a patient', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      expect(await repository.isPatient(uid), false);

    });

    test('Is patient can throw exception', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      PatientRepository repository = PatientRepository(db: firestore);

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('patients').doc(uid))
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));

      expect(() => repository.isPatient(uid), throwsException);

    });

    test('Is patient can return true if user is a patient', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      firestore.collection('patients').doc(uid).set({'gender': 'M',});
      DocumentSnapshot test = await firestore.collection('patients').doc(uid).get();
      expect(test.data(), {'gender': 'M',});


      PatientRepository repository = PatientRepository(db: firestore);


      expect(await repository.isPatient(uid), true);

    });

  });
}