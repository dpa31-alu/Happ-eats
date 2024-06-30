import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/models/user.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:mock_exceptions/mock_exceptions.dart';

void main()  {


  group('Test User Repository', ()   {

    test('User can be added to batch for creation', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      UserRepository repository = UserRepository(db: firestore);


      WriteBatch batch =  firestore.batch();
      batch = await repository.createUser(batch, uid, 'newFirstName', 'newLastName', 'newTel', 'newGender');
      await batch.commit();
      DocumentSnapshot p = await firestore.doc('users/$uid').get();
      Map<String, dynamic> m = {'firstName': 'newFirstName', 'lastName': 'newLastName', 'tel': 'newTel', 'gender': 'newGender'};
      expect(p.data(), equals(m));
    });

    test('User can be added to batch for deletion', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      firestore.collection('users').doc(uid).set({'firstName': 'newFirstName',});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(), {'firstName': 'newFirstName',});
      WriteBatch batch = firestore.batch();

      batch = await repository.deleteUser(batch, uid);

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      expect(doc.data(), null);

    });

    test('User can be added to batch for updating phone', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      firestore.collection('users').doc(uid).set({'tel': 'newTel',});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(), {'tel': 'newTel',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateUserTel(batch, uid, 'telTest');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      expect(doc.data(), {'tel': 'telTest',});

    });

    test('User can be added to batch for updating firstName', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      firestore.collection('users').doc(uid).set({'firstName': 'firstName',});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(), {'firstName': 'firstName',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateUserFirstName(batch, uid, 'firstNameTest');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      expect(doc.data(), {'firstName': 'firstNameTest',});

    });

    test('User can be added to batch for updating lastName', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      firestore.collection('users').doc(uid).set({'lastName': 'lastName',});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(), {'lastName': 'lastName',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateUserLastName(batch, uid, 'lastNameTest');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      expect(doc.data(), {'lastName': 'lastNameTest',});

    });

    test('User can be added to batch for updating gender', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      firestore.collection('users').doc(uid).set({'gender': 'F',});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(), {'gender': 'F',});
      WriteBatch batch = firestore.batch();

      batch = await repository.updateUserGender(batch, uid, 'M');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      expect(doc.data(), {'gender': 'M',});

    });

    test('User can be added to batch for adding dishes', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      String id = "0212151512";

      firestore.collection('users').doc(uid).set({'dishes.$id': 'patatas',});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(),  {'dishes': {'0212151512': 'patatas'}});
      WriteBatch batch = firestore.batch();

      batch = await repository.addDishes(batch, id, uid, 'patatas');

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      expect(doc.data(), {'dishes': {'0212151512': 'patatas'}});

    });

    test('User can be added to batch for deleting dishes', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      String id = "0212151512";

      firestore.collection('users').doc(uid).set({'dishes.$id': 'patatas', 'firstName':'pepe'});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(),  {'dishes': {'0212151512': 'patatas'}, 'firstName':'pepe'});
      WriteBatch batch = firestore.batch();

      batch = await repository.removeDishes(batch, id, uid);

      batch.commit();
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      expect(doc.data(), {'dishes': {}, 'firstName':'pepe'});

    });

    test('User can be retrieved', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      String id = "0212151512";

      firestore.collection('users').doc(uid).set({'firstName':'pepe', 'lastName': 'juan', 'tel': '777777777', 'gender': 'M', 'dishes.$id': 'patatas'});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(),  {
        'firstName': 'pepe',
        'lastName': 'juan',
        'tel': '777777777',
        'gender': 'M',
        'dishes': {'0212151512': 'patatas'}
      });

      UserModel user = await repository.getUser(uid);

      expect(user.toMap(), {
        'user': uid,
        'firstName': 'pepe',
        'lastName': 'juan',
        'tel': '777777777',
        'gender': 'M',
        'dishes': {'0212151512': 'patatas'}
      });

    });

    test('User retrieval can cause exception', () async {

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      UserRepository repository = UserRepository(db: firestore);

      String id = "0212151512";

      firestore.collection('users').doc(uid).set({'firstName':'pepe', 'lastName': 'juan', 'tel': '777777777', 'gender': 'M', 'dishes.$id': 'patatas'});
      DocumentSnapshot test = await firestore.collection('users').doc(uid).get();
      expect(test.data(),  {
        'firstName': 'pepe',
        'lastName': 'juan',
        'tel': '777777777',
        'gender': 'M',
        'dishes': {'0212151512': 'patatas'}
      });

      whenCalling(Invocation.method(#get,  null))
          .on(firestore.collection('users').doc(uid))
          .thenThrow(FirebaseException(plugin: 'pe',code: 'bla'));

      expect(() => repository.getUser(uid), throwsException);

    });
  });
}