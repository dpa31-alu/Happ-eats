
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/models/application.dart';


import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';



void main()  {


  group('Test Application Repository', ()   {

    test('Application for user state returns correctly', () async {
      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      ApplicationRepository repository = ApplicationRepository(db: firestore);
      String id = firestore.collection('applications').doc().id;

      DateTime date = DateTime.now();

      firestore.collection('applications').doc(id).set({
        'user': uid,
        'firstName': 'firstName',
        'lastName': 'lastName',
        'gender': 'F',
        'medicalCondition': 'medicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': date,
        'objectives': 'objectives',
        'type': 'Patología',
        'state': 'Pending',
        'date': date,
      });
      DocumentSnapshot<Map<String, dynamic>> test = await firestore.collection('applications').doc(id).get();
      expect(test.data()!['user'], uid);

      Map<String, dynamic> p = await repository.getApplicationForUserState(uid);

      expect(p['user'], uid);


    });

    test('Application for user state returns exception', () async {
      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      ApplicationRepository repository = ApplicationRepository(db: firestore);
      String id = firestore.collection('applications').doc().id;

      DateTime date = DateTime.now();

      firestore.collection('applications').doc(id).set({
        'user': uid,
        'firstName': 'firstName',
        'lastName': 'lastName',
        'gender': 'F',
        'medicalCondition': 'medicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': date,
        'objectives': 'objectives',
        'type': 'Patología',
        'state': 'Pending',
        'date': date,
      });
      DocumentSnapshot<Map<String, dynamic>> test = await firestore.collection('applications').doc(id).get();
      expect(test.data()!['user'], uid);

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('applications').doc())
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));



      expect(()=> repository.getApplicationForUserState(uid), throwsException);

    });

    test('Application for user returns correctly', () async {

      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      ApplicationRepository repository = ApplicationRepository(db: firestore);
      String id = firestore.collection('applications').doc().id;

      DateTime date = DateTime.now();

      firestore.collection('applications').doc(id).set({
        'user': uid,
        'firstName': 'firstName',
        'lastName': 'lastName',
        'gender': 'F',
        'medicalCondition': 'medicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': date,
        'objectives': 'objectives',
        'type': 'Patología',
        'state': 'Pending',
        'date': date,
      });
      DocumentSnapshot<Map<String, dynamic>> test = await firestore.collection('applications').doc(id).get();
      expect(test.data()!['user'], uid);


      ApplicationModel p = await repository.getApplicationForUser(uid);

      expect(p.user, uid);


    });

    test('Application for user throws exception', () async {

      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      ApplicationRepository repository = ApplicationRepository(db: firestore);
      String id = firestore.collection('applications').doc().id;

      DateTime date = DateTime.now();

      firestore.collection('applications').doc(id).set({
        'user': uid,
        'firstName': 'firstName',
        'lastName': 'lastName',
        'gender': 'F',
        'medicalCondition': 'medicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': date,
        'objectives': 'objectives',
        'type': 'Patología',
        'state': 'Pending',
        'date': date,
      });
      DocumentSnapshot<Map<String, dynamic>> test = await firestore.collection('applications').doc(id).get();
      expect(test.data()!['user'], uid);

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('applications').doc())
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));



      expect(()=> repository.getApplicationForUser(uid), throwsException);

    });

    test('Applicacion creation added to batch correctly', () async {

      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      ApplicationRepository repository = ApplicationRepository(db: firestore);

      DateTime date = DateTime.now();

      WriteBatch batch = firestore.batch();
      repository.createApplication(batch, uid, 'newFirstName', 'newLastName', 'newGender', 'newMedicalCondition', 100, 100, date, 'newObjectives', 'newType');
      batch.commit();

      QuerySnapshot<Map<String, dynamic>> p = await firestore.collection('applications').where('user', isEqualTo: uid).get();
      expect(p.docs[0].data()['user'], uid,);
    });

    test('Application deletion added to batch correctly', () async {
      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      ApplicationRepository repository = ApplicationRepository(db: firestore);
      String id = firestore.collection('applications').doc().id;

      DateTime date = DateTime.now();

      firestore.collection('applications').doc(id).set({'user': uid,'type': 'Patología', 'state': 'Pending', 'date':date});
      DocumentSnapshot<Map<String, dynamic>> test = await firestore.collection('applications').doc(id).get();
      expect(test.data()!['user'], uid);



      WriteBatch batch = firestore.batch();
      repository.deleteApplication(batch, id);
      batch.commit();

      DocumentSnapshot<Map<String, dynamic>> p = await firestore.collection('applications').doc(id).get();
      expect(p.data(), null);

    });

    test('Application asigning added to batch correctly', () async {
      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      ApplicationRepository repository = ApplicationRepository(db: firestore);
      String id = firestore.collection('applications').doc().id;

      DateTime date = DateTime.now();

      await firestore.collection('applications').doc('casa').set({'user': uid,'type': 'Patología', 'state': 'Pending', 'date':date});
      DocumentSnapshot<Map<String, dynamic>> test = await firestore.collection('applications').doc('casa').get();
      expect(test.data()!['state'], 'Pending');
      //await firestore.collection('applications').doc('casa').set({'user': uid,'type': 'Patología', 'state': 'Assigned', 'date':date});


      WriteBatch batch = firestore.batch();
      await repository.assignApplication(batch, uid);
      await batch.commit();
     // print(firestore.dump());

      DocumentSnapshot<Map> p = await firestore.collection('applications').doc('casa').get();
      expect(p.data()!['state'], 'Accepted');


    });

    test('Application stream returns correct type and number', () async {
      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      ApplicationRepository repository = ApplicationRepository(db: firestore);



      for(int i = 0; i < 21; i++) {
        firestore.collection('applications').doc().set({'user': uid,'type': 'Patología', 'state': 'Pending', 'date':DateTime.now()});
      }
      DateTime date = DateTime.now();
      firestore.collection('applications').doc().set({'user': uid,'type': 'Patología', 'state': 'Pending', 'date':date});
      for(int i = 0; i < 21; i++) {
        await firestore.collection('applications').doc().set({'user': uid,'type': 'Peso', 'state': 'Pending', 'date':DateTime.now()});
      }

      repository.getAllApplicationsByType('Patología', 20).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 20);
        expect(snap.docChanges.first.doc.data(), {
        'user': uid,
        'type': 'Patología',
        'state': 'Pending',
        'date': Timestamp.fromDate(date)
        });
      }));


    });

  });
}