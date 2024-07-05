


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/controllers/diet_controller.dart';
import 'package:happ_eats/controllers/user_controller.dart';
import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/appointed_meal.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:happ_eats/models/dish.dart';
import 'package:happ_eats/models/message.dart';
import 'package:happ_eats/models/patient.dart';
import 'package:happ_eats/models/professional.dart';
import 'package:happ_eats/models/user.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:happ_eats/services/file_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthService>()])
@GenerateNiceMocks([MockSpec<FileService>()])
@GenerateNiceMocks([MockSpec<UserRepository>()])
@GenerateNiceMocks([MockSpec<PatientRepository>()])
@GenerateNiceMocks([MockSpec<ProfessionalRepository>()])
@GenerateNiceMocks([MockSpec<MessageRepository>()])
@GenerateNiceMocks([MockSpec<DishRepository>()])
@GenerateNiceMocks([MockSpec<AppointedMealRepository>()])
@GenerateNiceMocks([MockSpec<ApplicationRepository>()])
@GenerateNiceMocks([MockSpec<DietRepository>()])


void main() {

  final MockAuthService authService = MockAuthService();
  final MockFileService fileService = MockFileService();
  final MockFirebaseAuth auth = MockFirebaseAuth();

  final MockUserRepository userRepository = MockUserRepository();
  final MockPatientRepository patientRepository = MockPatientRepository();
  final MockProfessionalRepository professionalRepository = MockProfessionalRepository();
  final MockMessageRepository messageRepository = MockMessageRepository();
  final MockApplicationRepository applicationRepository = MockApplicationRepository();
  final MockDietRepository dietRepository = MockDietRepository();
  final MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
  final MockDishRepository dishRepository = MockDishRepository();



  group('Test User Controller', ()  {

    test('getUserData retrieves correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('users').doc(uid), {
        'firstName': 'nombre',
        'lastName': 'apellidos',
        'tel': 'newFirstName',
        'gender':'newLastName',
      });
      batch.set(firestore.collection('users').doc('test'), {
        'firstName': 'noNombre',
        'lastName': 'noapellidos',
        'tel': 'newFirstName',
        'gender':'newLastName',
      });
      await batch.commit();
      var user = await firestore.collection('users').doc(uid).get();

      when(userRepository.getUser(any)).thenAnswer((realInvocation) async =>
          UserModel.fromDocument(user)
      );

      controller.getUserData()!.listen(expectAsync1 ((snap) {
        expect(snap.user, uid);
      }));
    });


    test('getUserData returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

        expect(controller.getUserData(), null);
    });

    test('getUserDataFuture retrieves correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('users').doc(uid), {
        'firstName': 'nombre',
        'lastName': 'apellidos',
        'tel': 'newFirstName',
        'gender':'newLastName',
      });
      batch.set(firestore.collection('users').doc('test'), {
        'firstName': 'noNombre',
        'lastName': 'noapellidos',
        'tel': 'newFirstName',
        'gender':'newLastName',
      });
      await batch.commit();
      var user = await firestore.collection('users').doc(uid).get();

      when(userRepository.getUser(any)).thenAnswer((realInvocation) async =>
          UserModel.fromDocument(user)
      );

      var doc = await controller.getUserDataFuture();
      expect(doc!.user, uid);


    });


    test('getUserDataFuture returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(controller.getUserDataFuture(), null);
    });


    test('getPatientData retrieves correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('patients').doc(uid), {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'startingWeight': 100.0,
        'height': 100.0,
        'birthday': DateTime.now(),
      });
      batch.set(firestore.collection('patients').doc('test'), {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'startingWeight': 100.0,
        'height': 100.0,
        'birthday': DateTime.now(),
      });
      await batch.commit();
      var doc = await firestore.collection('patients').doc(uid).get();

      when(patientRepository.getPatient(any)).thenAnswer((realInvocation) async =>
          PatientModel.fromDocument(doc)
      );

      controller.getPatientData()!.listen(expectAsync1 ((snap) {
        expect(snap.user, uid);
      }));
   });


    test('getPatientData returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(controller.getPatientData(), null);
    });

    test('loginUser logs correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      when(authService.login('email', 'password')).thenAnswer((realInvocation) => auth.signInWithEmailAndPassword(email: 'email', password: 'password'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.loginUser('email', 'password'), null);
    });

    test('loginUser returns correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      when(authService.login('email', 'password')).thenAnswer((realInvocation) => throw FirebaseAuthException(code: 'code', message: 'error'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.loginUser('email', 'password'), 'error');
    });


    test('logoutUser logs correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      when(authService.logout()).thenAnswer((realInvocation) async => true);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.logoutUser(), null);
    });

    test('logoutUser returns error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      when(authService.logout()).thenAnswer((realInvocation) => throw FirebaseAuthException(code: 'code', message: 'error'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.logoutUser(), 'error');
    });

    test('getCurrentUserId returns correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.getCurrentUserUid(), uid);
    });

    test('getCurrentUserId returns null on error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => null);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.getCurrentUserUid(), null);
    });

    test('updateUserTel updates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('users').doc(uid), {
        'firstName': 'nombre',
        'lastName': 'apellidos',
        'tel': 'newFirstName',
        'gender':'newLastName',
      });
      await batch.commit();
      WriteBatch batch2 = firestore.batch();
      batch2.update(firestore.collection('users').doc(uid), {
        'firstName': 'nombre',
        'lastName': 'apellidos',
        'tel': '123456789',
        'gender':'newLastName',
      });
      //await batch2.commit();


      when(userRepository.updateUserTel(any, uid, '123456789')).thenAnswer((realInvocation) async =>
          batch2
      );

      await controller.updateUserTel('123456789');

      var doc = await firestore.collection('users').doc(uid).get();
      expect(doc['tel'], '123456789');


    });


    test('updateUserTel returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.updateUserTel('123456789'), null);
    });

    test('updateUserFirstName updates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      String newName = 'Pepe';

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('users').doc(uid), {
        'firstName': 'nombre',
        'lastName': 'apellidos',
        'tel': '123456789',
        'gender':'newLastName',
      });
      batch.set(firestore.collection('diets').doc('test'), {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });
      await batch.commit();
      WriteBatch batch2 = firestore.batch();
      batch2.update(firestore.collection('users').doc(uid), {
        'firstName': newName,
      });
      batch2.update(firestore.collection('diets').doc('test'), {
        'firstName': newName,
      });


      when(userRepository.updateUserFirstName(any, uid, newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(dietRepository.updateDietFirstName(any, 'test', newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.updateUserFirstName(newName, {
        'uid':'test',
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });

      var doc = await firestore.collection('users').doc(uid).get();
      expect(doc['firstName'], newName);

      var doc2 = await firestore.collection('diets').doc('test').get();
      expect(doc2['firstName'], newName);

    });


    test('updateUserFirstName returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.updateUserFirstName('123456789', {
        'uid':'test',}), null);
    });

    test('updateUserLastName updates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      String newName = 'Pepe';

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('users').doc(uid), {
        'firstName': 'nombre',
        'lastName': 'apellidos',
        'tel': '123456789',
        'gender':'newLastName',
      });
      batch.set(firestore.collection('diets').doc('test'), {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });
      await batch.commit();
      WriteBatch batch2 = firestore.batch();
      batch2.update(firestore.collection('users').doc(uid), {
        'lastName': newName,
      });
      batch2.update(firestore.collection('diets').doc('test'), {
        'lastName': newName,
      });


      when(userRepository.updateUserLastName(any, uid, newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(dietRepository.updateDietLastName(any, 'test', newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.updateUserLastName(newName, {
        'uid':'test',
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });

      var doc = await firestore.collection('users').doc(uid).get();
      expect(doc['lastName'], newName);

      var doc2 = await firestore.collection('diets').doc('test').get();
      expect(doc2['lastName'], newName);

    });


    test('updateUserFirstName returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.updateUserLastName('123456789', {
        'uid':'test',}), null);
    });

    test('updatePatientMedicalCondition updates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      String newName = 'F';

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('users').doc(uid), {
        'firstName': 'nombre',
        'lastName': 'apellidos',
        'tel': '123456789',
        'gender':'M',
      });
      batch.set(firestore.collection('patients').doc(uid), {
        'gender': 'M',
        'medicalCondition': 'newMedicalCondition',
        'weight': double.parse('100'),
        'startingWeight': double.parse('100'),
        'height': double.parse('100'),
        'birthday': DateTime.now(),
      });
      batch.set(firestore.collection('diets').doc('test'), {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'M',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });
      await batch.commit();
      WriteBatch batch2 = firestore.batch();
      batch2.update(firestore.collection('users').doc(uid), {
        'gender': 'F',
      });
      batch2.update(firestore.collection('patients').doc(uid), {
        'gender': 'F',
      });
      batch2.update(firestore.collection('diets').doc('test'), {
        'gender': 'F',
      });

      when(userRepository.updateUserGender(any, uid, newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(patientRepository.updatePatientGender(any, uid, newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(dietRepository.updateDietGender(any, 'test', newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.updatePatientGender(newName, {
        'uid':'test',
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      }, true);

      var doc = await firestore.collection('patients').doc(uid).get();
      expect(doc['gender'], newName);

      var doc2 = await firestore.collection('diets').doc('test').get();
      expect(doc2['gender'], newName);

      var doc3 = await firestore.collection('users').doc(uid).get();
      expect(doc3['gender'], newName);

    });


    test('updatePatientGender returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.updatePatientGender('123456789', {
        'uid':'test', }, true), null);
    });

    test('updatePatientMedicalCondition updates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      String newName = 'Mal';

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('patients').doc(uid), {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': double.parse('100'),
        'startingWeight': double.parse('100'),
        'height': double.parse('100'),
        'birthday': DateTime.now(),
      });
      batch.set(firestore.collection('diets').doc('test'), {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });
      await batch.commit();
      WriteBatch batch2 = firestore.batch();
      batch2.update(firestore.collection('patients').doc(uid), {
        'medicalCondition': 'Mal',
      });
      batch2.update(firestore.collection('diets').doc('test'), {
        'medicalCondition': 'Mal',
      });


      when(patientRepository.updatePatientMedicalCondition(any, uid, newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(dietRepository.updateDietMedicalCondition(any, 'test', newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.updatePatientMedicalCondition(newName, {
        'uid':'test',
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });

      var doc = await firestore.collection('patients').doc(uid).get();
      expect(doc['medicalCondition'], newName);

      var doc2 = await firestore.collection('diets').doc('test').get();
      expect(doc2['medicalCondition'], newName);

    });


    test('updatePatientMedicalCondition returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.updatePatientMedicalCondition('123456789', {
        'uid':'test',}), null);
    });

    test('updatePatientWeight updates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      String newName = '200.0';

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('patients').doc(uid), {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': double.parse('100'),
        'startingWeight': double.parse('100'),
        'height': double.parse('100'),
        'birthday': DateTime.now(),
      });
      batch.set(firestore.collection('diets').doc('test'), {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });
      await batch.commit();
      WriteBatch batch2 = firestore.batch();
      batch2.update(firestore.collection('patients').doc(uid), {
        'weight': newName,
      });
      batch2.update(firestore.collection('diets').doc('test'), {
        'weight': newName,
      });


      when(patientRepository.updatePatientWeight(any, uid, newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(dietRepository.updateDietWeight(any, 'test', newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.updatePatientWeight(newName, {
        'uid':'test',
      });

      var doc = await firestore.collection('patients').doc(uid).get();
      expect(doc['weight'], newName);

      var doc2 = await firestore.collection('diets').doc('test').get();
      expect(doc2['weight'], newName);

    });


    test('updatePatientWeight returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.updatePatientWeight('123456789', {
        'uid':'test',}), null);
    });

    test('updatePatientHeight updates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      String newName = '200.0';

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('patients').doc(uid), {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': double.parse('100'),
        'startingWeight': double.parse('100'),
        'height': double.parse('100'),
        'birthday': DateTime.now(),
      });
      batch.set(firestore.collection('diets').doc('test'), {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });
      await batch.commit();
      WriteBatch batch2 = firestore.batch();
      batch2.update(firestore.collection('patients').doc(uid), {
        'height': newName,
      });
      batch2.update(firestore.collection('diets').doc('test'), {
        'height': newName,
      });


      when(patientRepository.updatePatientHeight(any, uid, newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(dietRepository.updateDietHeight(any, 'test', newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.updatePatientHeight(newName, {
        'uid':'test',
      });

      var doc = await firestore.collection('patients').doc(uid).get();
      expect(doc['height'], newName);

      var doc2 = await firestore.collection('diets').doc('test').get();
      expect(doc2['height'], newName);

    });


    test('updatePatientHeight returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.updatePatientHeight('123456789', {
        'uid':'test',}), null);
    });

    test('updatePatientBirthday updates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      String newName = '2000-12-12';

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('patients').doc(uid), {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': double.parse('100'),
        'startingWeight': double.parse('100'),
        'height': double.parse('100'),
        'birthday': DateTime.now(),
      });
      batch.set(firestore.collection('diets').doc('test'), {
        'patient': uid,
        'professional': uid,
        'firstName': 'newFirstName',
        'lastName':'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'date': DateTime.timestamp(),
      });
      await batch.commit();
      WriteBatch batch2 = firestore.batch();
      batch2.update(firestore.collection('patients').doc(uid), {
        'birthday': newName,
      });
      batch2.update(firestore.collection('diets').doc('test'), {
        'birthday': newName,
      });


      when(patientRepository.updatePatientBirthday(any, uid, newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(dietRepository.updateDietBirthday(any, 'test', newName)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.updatePatientBirthday(newName, {
        'uid':'test',
      });

      var doc = await firestore.collection('patients').doc(uid).get();
      expect(doc['birthday'], newName);

      var doc2 = await firestore.collection('diets').doc('test').get();
      expect(doc2['birthday'], newName);

    });


    test('updatePatientBirthday returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.updatePatientBirthday('123456789', {
        'uid':'test',}), null);
    });

    test('createUserProfessional creates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.createUser('email', 'password')).thenAnswer((realInvocation) => auth.createUserWithEmailAndPassword(email: 'email', password: 'password'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);



      WriteBatch batch2 = firestore.batch();
      batch2.set(firestore.collection('professionals').doc(uid), {
        'collegeNumber':'collegeNumber'
      });
      batch2.set(firestore.collection('users').doc(uid), {
        'tel':'tel'
      });


      when(professionalRepository.createProfessional(any, any, any)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(userRepository.createUser(any, any, any,any,any, any)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.createUserProfessional('email','password','tel', 'firstName', 'lastName', 'collegeNumber', 'gender' );

      var doc = await firestore.collection('professionals').doc(uid).get();
      expect(doc['collegeNumber'], 'collegeNumber');

      var doc2 = await firestore.collection('users').doc(uid).get();
      expect(doc2['tel'], 'tel');

      expect(auth.currentUser!.email, 'email');

    });


    test('createUserProfessional returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.createUser('email', 'password')).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'ex'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect( await controller.createUserProfessional('email','password','tel', 'firstName', 'lastName', 'collegeNumber', 'gender' ), 'ex');
    });

    test('createUserPatient creates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.createUser('email', 'password')).thenAnswer((realInvocation) => auth.createUserWithEmailAndPassword(email: 'email', password: 'password'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);



      WriteBatch batch2 = firestore.batch();
      batch2.set(firestore.collection('patients').doc(uid), {
        'weight':'100.0'
      });
      batch2.set(firestore.collection('users').doc(uid), {
        'tel':'tel'
      });


      when(patientRepository.createPatient(any, any, any, any, any, any, any)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(userRepository.createUser(any, any, any,any,any, any)).thenAnswer((realInvocation) async =>
      batch2
      );

      await controller.createUserPatient('email', 'password', 'tel', 'firstName', 'lastName', 'birthday', 'gender', 'medicalCondition', '100.0', '100.0');

      var doc = await firestore.collection('patients').doc(uid).get();
      expect(doc['weight'], '100.0');

      var doc2 = await firestore.collection('users').doc(uid).get();
      expect(doc2['tel'], 'tel');

      expect(auth.currentUser!.email, 'email');

    });


    test('createUserPatient returns null if error', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.createUser('email', 'password')).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'ex'));

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect( await  controller.createUserPatient('email', 'password', 'tel', 'firstName', 'lastName', 'birthday', 'gender', 'medicalCondition', '100.0', '100.0')
          , 'ex');
    });

    test('isPatient creates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);



      WriteBatch batch2 = firestore.batch();
      batch2.set(firestore.collection('patients').doc(uid), {
        'weight':'100.0'
      });
      batch2.set(firestore.collection('users').doc(uid), {
        'tel':'tel'
      });


      when(patientRepository.isPatient(uid)).thenAnswer((realInvocation) async =>
      true
      );

      when(patientRepository.isPatient('uid')).thenAnswer((realInvocation) async =>
      false
      );
      controller.isPatient(uid).listen(expectAsync1 ((snap) {
        expect(snap, true);
      }));

      controller.isPatient('uid').listen(expectAsync1 ((snap) {
        expect(snap, false);
      }));

    });

    test('deleteUserProfessional deletes correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('professional').doc(uid), {
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': double.parse('100'),
        'startingWeight': double.parse('100'),
        'height': double.parse('100'),
        'birthday': DateTime.now(),
      });
      batch.set(firestore.collection('users').doc(uid), {
        'tel': 'tel',
      });
      batch.commit();

      WriteBatch batch2 = firestore.batch();
      batch2.delete(firestore.collection('professionals').doc(uid));
      batch2.delete(firestore.collection('users').doc(uid));

      when(professionalRepository.deleteProfessional(any, any)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(userRepository.deleteUser(any, any)).thenAnswer((realInvocation) async =>
      batch2
      );

      when(authService.getCurrentUser()).thenAnswer((realInvocation)  => auth.currentUser);

      when(authService.deleteUser(uid)).thenAnswer((realInvocation)  => auth.currentUser!.delete());

      when(dietRepository.getAllDietsForProfessional(uid)).thenAnswer((realInvocation) => firestore.collection('diets').get());

      when(dishRepository.getAllDishesFuture(uid)).thenAnswer((realInvocation) => firestore.collection('dishes').get());

      await controller.deleteUserProfessional();

      var doc = await firestore.collection('patients').doc(uid).get();
      expect(doc.data(), null);

      var doc2 = await firestore.collection('users').doc(uid).get();
      expect(doc2.data(), null);

    });

    test('deleteUserProfessional returns error code', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      UsersController controller = UsersController(db: firestore, auth: authService,
          repositoryUser: userRepository, repositoryProfessional: professionalRepository, repositoryMessages: messageRepository,
          repositoryPatient: patientRepository, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository,
          repositoryApplication: applicationRepository, repositoryDiets: dietRepository);


      when(dietRepository.getAllDietsForProfessional(uid)).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'plugin', message: 'error'));

      expect(controller.deleteUserProfessional(), 'error');


    });

  });
}