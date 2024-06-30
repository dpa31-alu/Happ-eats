import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/controllers/dish_controller.dart';
import 'package:happ_eats/models/dish.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/models/user.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:happ_eats/services/file_service.dart';


import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dish_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DishRepository>()])
@GenerateNiceMocks([MockSpec<FileService>()])
@GenerateNiceMocks([MockSpec<UserRepository>()])
@GenerateNiceMocks([MockSpec<AuthService>()])

void main()  {



  group('Test Dish Controller', ()   {


    test('retrieveAllDishesForUser retrieves correctly', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);

      for(int i = 0; i < 21; i++) {
        firestore.collection('dishes').doc().set({'user': uid});
      }

      when(authMock.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      when(dishMock.getAllDishes(20, any)).thenAnswer((realInvocation) => firestore.collection('dishes').where('user', isEqualTo: uid).limit(20).snapshots());

      controller.retrieveAllDishesForUser(20).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 20);
      }));

    });

    test('createDish creates correctly', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);

      WriteBatch batch =  firestore.batch();

      String id = firestore.collection('dishes').doc().id;

      batch.set(firestore.collection('dishes')
          .doc(id), {
        'user': uid,
        'name': 'dishName',
        'description': 'description',
        'image':null,
        'nutritionalInfo': {},
        'ingredients': {},
      });

      WriteBatch batch2 =  firestore.batch();


      batch2.set(firestore.collection('dishes')
          .doc(id), {
        'user': uid,
        'name': 'dishName',
        'description': 'description',
        'image':null,
        'nutritionalInfo': {},
        'ingredients': {},
      });


      batch2.set(firestore.collection('users')
          .doc(uid), {
        'dishes.$id': 'dishName',
      });


      when(authMock.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      when(userMock.addDishes(any, any, uid, 'dishName')).thenAnswer((realInvocation) async => batch);

      when(dishMock.createDish(any, any, uid, 'dishName', 'description',
          {}, null,
          {})).thenAnswer((realInvocation) async => batch2);

      expect(await controller.createDish('dishName', 'description', {}, null,
          {}), null);

      DocumentSnapshot<Map<String, dynamic>> test1 = await firestore.collection('dishes').doc(id).get();

      expect(test1.data()!['user'], uid);

      DocumentSnapshot<Map<String, dynamic>> test2 = await firestore.collection('users').doc(uid).get();

      expect(test2.data()!['dishes'], {id: 'dishName'});

    });

    test('createDish creates correctly', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);

      when(authMock.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      when(userMock.addDishes(any, any, uid, 'dishName')).thenAnswer((realInvocation) async => throw FirebaseException(plugin: 'ye', message: 'error'));

      expect(await controller.createDish('dishName', 'description', {}, null,
          {}), 'error');

    });

    test('copyDish creates correctly', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);

      WriteBatch batch =  firestore.batch();

      String id = firestore.collection('dishes').doc().id;

      batch.set(firestore.collection('dishes')
          .doc(id), {
        'user': uid,
        'name': 'dishName',
        'description': 'description',
        'image':null,
        'nutritionalInfo': {},
        'ingredients': {},
      });

      WriteBatch batch2 =  firestore.batch();


      batch2.set(firestore.collection('dishes')
          .doc(id), {
        'user': uid,
        'name': 'dishName',
        'description': 'description',
        'image':null,
        'nutritionalInfo': {},
        'ingredients': {},
      });


      batch2.set(firestore.collection('users')
          .doc(uid), {
        'dishes.$id': 'dishName',
      });


      when(authMock.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      when(userMock.addDishes(any, any, uid, 'dishName')).thenAnswer((realInvocation) async => batch);

      when(dishMock.createDish(any, any, uid, 'dishName', 'description',
          {}, null,
          {})).thenAnswer((realInvocation) async => batch2);

      expect(await controller.copyDish('dishName', 'description', {},
          {}), null);

      DocumentSnapshot<Map<String, dynamic>> test1 = await firestore.collection('dishes').doc(id).get();

      expect(test1.data()!['user'], uid);

      DocumentSnapshot<Map<String, dynamic>> test2 = await firestore.collection('users').doc(uid).get();

      expect(test2.data()!['dishes'], {id: 'dishName'});

    });

    test('copyDish creates correctly', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);

      when(authMock.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      when(userMock.addDishes(any, any, uid, 'dishName')).thenAnswer((realInvocation) async => throw FirebaseException(plugin: 'ye', message: 'error'));

      expect(await controller.copyDish('dishName', 'description', {},
          {}), 'error');

    });

    test('retrieveDishForUser return right dish', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);


      String id = firestore.collection('dishes').doc().id;


      WriteBatch batch2 =  firestore.batch();


      batch2.set(firestore.collection('dishes')
          .doc(id), {
        'user': uid,
        'name': 'dishName',
        'description': 'description',
        'image':null,
        'nutritionalInfo': {},
        'ingredients': {},
      });


      batch2.set(firestore.collection('users')
          .doc(uid), {
        'dishes.$id': 'dishName',
      });

      await batch2.commit();

      when(dishMock.getDish(uid)).thenAnswer((realInvocation) async => firestore.collection('dishes').doc(id).get());

      DocumentSnapshot<Map<String, dynamic>>? test = await controller.retrieveDishForUser(uid);

      expect(test!.id, id);

    });

    test('retrieveDishForUser catches and returns error', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);

      when(dishMock.getDish(uid)).thenAnswer((realInvocation) async => throw FirebaseException(plugin: 'ye', message: 'error'));

      expect(await controller.retrieveDishForUser(uid), null);

    });

    test('deleteDish deletes correctly', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);

      String id = firestore.collection('dishes').doc().id;

      WriteBatch batch =  firestore.batch();

      batch.set(firestore.collection('dishes')
          .doc(id), {
        'user': uid,
        'name': 'dishName',
        'description': 'description',
        'image':null,
        'nutritionalInfo': {},
        'ingredients': {},
      });

      batch.set(firestore.collection('users')
          .doc(uid), {
        'dishes.$id': 'dishName',
      });

      await batch.commit();

      WriteBatch batch1 =  firestore.batch();

      batch1.update(firestore.collection('users')
          .doc(uid), {
        'dishes.$id': FieldValue.delete(),
      });

      WriteBatch batch2 =  firestore.batch();

      batch2.delete(firestore.collection('dishes').doc(id));

      batch2.update(firestore.collection('users')
          .doc(uid), {
        'dishes.$id': FieldValue.delete(),
      });

      when(userMock.removeDishes(any, id, uid)).thenAnswer((realInvocation) async => batch1);

      when(dishMock.deleteDish(any, id)).thenAnswer((realInvocation) async => batch2);

      await controller.deleteDish(id, uid, null);

      DocumentSnapshot<Map<String, dynamic>> pepe = await firestore.collection('dishes').doc(id).get();

      expect(pepe.data(), null);

    });

    test('deleteDish catches and returns error', () async {

      MockDishRepository dishMock = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      MockAuthService authMock = MockAuthService();

      MockFileService fileMock = MockFileService();

      MockUserRepository userMock = MockUserRepository();

      DishesController controller = DishesController(db: firestore, auth: authMock, file: fileMock, repositoryUser: userMock, repositoryDish: dishMock,);

      String id = firestore.collection('dishes').doc().id;

      when(userMock.removeDishes(any, id, uid)).thenAnswer((realInvocation) async => throw FirebaseException(plugin: 'ye', message: 'error'));

      expect(await controller.deleteDish(id, uid, null), 'error');

    });

  });

}