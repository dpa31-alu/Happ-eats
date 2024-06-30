import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/controllers/diet_controller.dart';

import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:happ_eats/models/message.dart';
import 'package:happ_eats/models/user.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:happ_eats/services/file_service.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'diet_controller_test.mocks.dart';


@GenerateNiceMocks([MockSpec<AuthService>()])
@GenerateNiceMocks([MockSpec<FileService>()])
@GenerateNiceMocks([MockSpec<UserRepository>()])
@GenerateNiceMocks([MockSpec<MessageRepository>()])
@GenerateNiceMocks([MockSpec<ApplicationRepository>()])
@GenerateNiceMocks([MockSpec<DietRepository>()])


void main() {
  group('Test Diet Controller', () {


    final MockAuthService authService = MockAuthService();
    final MockFileService fileService = MockFileService();
    final MockFirebaseAuth auth = MockFirebaseAuth();

    final MockUserRepository userRepository = MockUserRepository();
    final MockMessageRepository messageRepository = MockMessageRepository();
    final MockApplicationRepository applicationRepository = MockApplicationRepository();
    final MockDietRepository dietRepository = MockDietRepository();

    test('createDiet creates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      await firestore.collection('applications').doc('test').set({'state':'Pending'});

      DietsController controller = DietsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryMessages: messageRepository, repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      WriteBatch batch = firestore.batch();
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
      batch.update(firestore.collection('applications').doc('test'), {
        'state': 'Approved'
      });
      batch.set(firestore.collection('chatrooms').doc('$uid$uid').collection('messages').doc('test'), {
        'toId': uid,
      });

      when(applicationRepository.assignApplication(any, uid)).thenAnswer((realInvocation) async =>
      batch
      );
      when(userRepository.getUser(uid)).thenAnswer((realInvocation) async =>
      UserModel(firstName: 'firstName', lastName: 'lastName', tel: 'tel', gender: 'newGender')
      );
      when(dietRepository.createDiet(any, uid, uid, 'newFirstName', 'newLastName', 'newGender', 'newMedicalCondition', 100.0, 150.0, date1, 'newObjectives', 'newType')).thenAnswer((realInvocation) async =>
      batch
      );
      when(messageRepository.sendMessage(any, '$uid$uid', uid, uid, 'Este es un mensaje automatizado para comunicarle que su solicitud ha sido procesada y aceptada por el profesional: firstName lastName')).thenAnswer((realInvocation) async =>
      batch
      );


      expect(await controller.createDiet(uid, 'newFirstName', 'newLastName', 'newGender', 'newMedicalCondition', 100.0, 150.0, date1, 'newObjectives', 'newType'), null);

      DocumentSnapshot<Map<String, dynamic>> snap = await firestore.collection('diets').doc('test').get();

      expect(snap.data()!['patient'], uid);

    });

    test('createDiet catches exception and returns message', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));

      DietsController controller = DietsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryMessages: messageRepository, repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.createDiet('patient', 'firstName', 'lastName', 'gender', 'medicalCondition', 100, 100, date1, 'objectives', 'type')  , 'error');

    });

    test('retrieveAllDiets retrieves correct amount', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      DietsController controller = DietsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryMessages: messageRepository, repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      WriteBatch batch = firestore.batch();
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
      batch.set(firestore.collection('diets').doc('test1'), {
        'patient': uid,
        'professional': 'uid',
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
      batch.set(firestore.collection('diets').doc('test2'), {
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
        'type': 'Type',
        'date': DateTime.timestamp(),
      });
      await batch.commit();

      when(dietRepository.getAllDiets('newType', 3, uid)).thenAnswer((realInvocation) =>
         firestore.collection('diets').where('professional', isEqualTo: uid).where('type', isEqualTo: 'newType').snapshots()
      );

      controller.retrieveAllDiets('newType', 3).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 1);
        expect(snap.docChanges.first.doc.data()!['type'], 'newType');
      }));

    });

    test('retrieveDietForUserStream retrieves correct amount', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      DietsController controller = DietsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryMessages: messageRepository, repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      WriteBatch batch = firestore.batch();
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

      when(dietRepository.getDietForUser(uid)).thenAnswer((realInvocation) async =>
      {
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
      }
      );

      controller.retrieveDietForUserStream().listen(expectAsync1 ((snap) {
        expect(snap['type'], 'newType');
      }));

    });

    test('retrieveDietForUser retrieves correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      DietsController controller = DietsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryMessages: messageRepository, repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      DateTime date = DateTime.timestamp();

      WriteBatch batch = firestore.batch();
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
        'date': date,
      });
      await batch.commit();

      when(dietRepository.getDietForUser(uid)).thenAnswer((realInvocation) async =>
      {
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
        'date': date,
      }
      );

      expect(await controller.retrieveDietForUser(), {
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
        'date': date,
      });

    });

    test('retrieveDietForUser catches exception and returns empty map', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));

      DietsController controller = DietsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryMessages: messageRepository, repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.retrieveDietForUser(), {});

    });

    test('addFile retrieves correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      DietsController controller = DietsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryMessages: messageRepository, repositoryApplication: applicationRepository, repositoryDiets: dietRepository);


      WriteBatch batch = firestore.batch();
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

      expect(await controller.addFile(uid, uid), 'Seleccione un archivo.');

      final imageTestFile = 'assets/images/gochujang.jpg';
      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult pepe =  FilePickerResult([platformFile]);

      when(fileService.getDietFile()).thenAnswer((realInvocation) async => pepe);

      WriteBatch batch2 = firestore.batch();
      batch2.set(firestore.collection('diets').doc('test'), {
        'url' : 'file'
      });
      when(dietRepository.addRefApplication(any, uid, 'file')).thenAnswer((realInvocation) async => batch2);
      when(fileService.uploadDietFile(pepe, uid)).thenAnswer((realInvocation) async => 'file');

      expect(await controller.addFile(uid, uid), null);

    });

    test('addFile catches exception and returns empty map', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;
      DateTime date1 = DateTime.now();

      when(fileService.getDietFile()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));

      DietsController controller = DietsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryMessages: messageRepository, repositoryApplication: applicationRepository, repositoryDiets: dietRepository);

      expect(await controller.addFile(uid, uid), 'error');

    });

  });
}