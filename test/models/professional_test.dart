import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/models/professional.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:mock_exceptions/mock_exceptions.dart';

void main()  {


  group('Test Professional Repository', ()   {

    test('Professional can be added to batch for creation', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      ProfessionalRepository repository = ProfessionalRepository(db: firestore);


      WriteBatch batch =  firestore.batch();
      batch = await repository.createProfessional(batch, uid, 'collegeNumber');
      await batch.commit();

      DocumentSnapshot p = await firestore.doc('professionals/$uid').get();
      Map<String, dynamic> m = {'collegeNumber': 'collegeNumber',};
      expect(p.data(), equals(m));
    });

    test('Professional can be added to batch for deletion', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      ProfessionalRepository repository = ProfessionalRepository(db: firestore);

      firestore.collection('professionals').doc(uid).set({'collegeNumber': 'collegeNumber',});
      DocumentSnapshot test = await firestore.collection('professionals').doc(uid).get();
      expect(test.data(), {'collegeNumber': 'collegeNumber',});
      WriteBatch batch = firestore.batch();

      batch = await repository.deleteProfessional(batch, uid);

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('professionals').doc(uid).get();
      expect(doc.data(), null);

    });

    test('Professional can be retrieved', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      ProfessionalRepository repository = ProfessionalRepository(db: firestore);


      firestore.collection('professionals').doc(uid).set({'collegeNumber': 'collegeNumber',});
      DocumentSnapshot test = await firestore.collection('professionals').doc(uid).get();
      expect(test.data(),
      {'collegeNumber': 'collegeNumber',}
      );

      ProfessionalModel user = await repository.getProfessional(uid);




      expect(user.toMap(), {
        'user': uid,
        'collegeNumber': 'collegeNumber',
        }
      );

    });

    test('Professional retrieval can cause exception', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      ProfessionalRepository repository = ProfessionalRepository(db: firestore);


      firestore.collection('professionals').doc(uid).set({'collegeNumber': 'collegeNumber',});
      DocumentSnapshot test = await firestore.collection('professionals').doc(uid).get();
      expect(test.data(),
          {'collegeNumber': 'collegeNumber',}
      );


      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('professionals').doc(uid))
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));

      expect(() => repository.getProfessional(uid), throwsException);

    });



  });
}