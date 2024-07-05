import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/controllers/application_controller.dart';



import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/appointed_meal.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:happ_eats/models/message.dart';
import 'package:happ_eats/models/patient.dart';
import 'package:happ_eats/models/user.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:happ_eats/services/file_service.dart';




import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'application_controller_test.mocks.dart';




@GenerateNiceMocks([MockSpec<AuthService>()])
@GenerateNiceMocks([MockSpec<FileService>()])
@GenerateNiceMocks([MockSpec<UserRepository>()])
@GenerateNiceMocks([MockSpec<PatientRepository>()])
@GenerateNiceMocks([MockSpec<MessageRepository>()])
@GenerateNiceMocks([MockSpec<AppointedMealRepository>()])
@GenerateNiceMocks([MockSpec<ApplicationRepository>()])
@GenerateNiceMocks([MockSpec<DietRepository>()])


void main() {
  group('Test Appplication Controller', () {


    final MockAuthService authService = MockAuthService();
    final MockFileService fileService = MockFileService();
    final MockFirebaseAuth auth = MockFirebaseAuth();

    final MockUserRepository userRepository = MockUserRepository();
    final MockPatientRepository patientRepository = MockPatientRepository();
    final MockMessageRepository messageRepository = MockMessageRepository();
    final MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
    final MockApplicationRepository applicationRepository = MockApplicationRepository();
    final MockDietRepository dietRepository = MockDietRepository();


    test('getApplicationsByTypeStream retrieves correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      ApplicationsController controller = ApplicationsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryPatient: patientRepository,
          repositoryAppointedMeal: appointedMealRepository, repositoryApplication: applicationRepository,
          repositoryMessages: messageRepository, repositoryDiets: dietRepository);

      DateTime date1 = DateTime.now();

      for(int i = 0; i < 5; i++) {
        await firestore.collection('applications').doc().set({
          'uid': uid,
          'user': 'user',
          'firstName': 'firstName',
          'lastName': 'lastName',
          'gender': 'gender',
          'medicalCondition': 'medicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': date1,
          'objectives': 'objectives',
          'type': 'Patología',
          'state': 'Pending',
          'date': date1,
        });
        await firestore.collection('applications').doc().set({
          'uid': uid,
          'user': 'user',
          'firstName': 'firstName',
          'lastName': 'lastName',
          'gender': 'gender',
          'medicalCondition': 'medicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': 'birthday',
          'objectives': 'objectives',
          'type': 'Peso',
          'state': 'Approved',
          'date': 'date',
        });
      }
      DateTime date2 = DateTime.now();
      for(int i = 0; i < 5; i++) {
       await firestore.collection('applications').doc().set({
          'uid': uid,
          'user': 'user',
          'firstName': 'firstName',
          'lastName': 'lastName',
          'gender': 'gender',
          'medicalCondition': 'medicalCondition',
          'weight': 100.0,
          'height': 100.0,
          'birthday': date2,
          'objectives': 'objectives',
          'type': 'Patología',
          'state': 'Pending',
          'date': date2,
        });
      }

      when(applicationRepository.getAllApplicationsByType(any, any)).thenAnswer((realInvocation) => firestore.collection('applications').where('state', isEqualTo: 'Pending').where('type', isEqualTo: 'Patología').orderBy('date', descending: true).limit(20).snapshots());

      controller.getApplicationsByTypeStream('Patología', 20).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 10);
        expect(snap.docChanges.first.doc.data(), {
        'uid': uid,
        'user': 'user',
        'firstName': 'firstName',
        'lastName': 'lastName',
        'gender': 'gender',
        'medicalCondition': 'medicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': Timestamp.fromDate(date2),
        'objectives': 'objectives',
        'type': 'Patología',
        'state': 'Pending',
        'date': Timestamp.fromDate(date2)
        });
      }));

    });

    test('getApplicationForUserState retrieves correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      ApplicationsController controller = ApplicationsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryPatient: patientRepository,
          repositoryAppointedMeal: appointedMealRepository, repositoryApplication: applicationRepository,
          repositoryMessages: messageRepository, repositoryDiets: dietRepository);

      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      when(applicationRepository.getApplicationForUserState(uid)).thenAnswer((realInvocation) async =>
      {
        'uid': uid,
        'user': uid,
        'firstName': 'firstName',
        'lastName': 'lastName',
        'gender': 'gender',
        'medicalCondition': 'medicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': Timestamp.fromDate(date1),
        'objectives': 'objectives',
        'type': 'Patología',
        'state': 'Pending',
        'date': Timestamp.fromDate(date1),
      }
      );

      controller.getApplicationForUserState().listen(expectAsync1 ((snap) {
        expect(snap, {
        'uid': uid,
        'user': uid,
        'firstName': 'firstName',
        'lastName': 'lastName',
        'gender': 'gender',
        'medicalCondition': 'medicalCondition',
        'weight': 100.0,
        'height': 100.0,
        'birthday': Timestamp.fromDate(date1),
        'objectives': 'objectives',
        'type': 'Patología',
        'state': 'Pending',
        'date': Timestamp.fromDate(date1)
        });
      }));


    });

    test('CreateApplication creates correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      ApplicationsController controller = ApplicationsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryPatient: patientRepository,
          repositoryAppointedMeal: appointedMealRepository, repositoryApplication: applicationRepository,
          repositoryMessages: messageRepository, repositoryDiets: dietRepository);

      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      await firestore.collection('users').doc(uid).set({
        'firstName': 'newFirstName',
        'lastName': 'newLastName',
        'tel': 'newTel',
        'gender': 'newGender'
      });


      await firestore.collection('patients')
          .doc(uid).set({
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'startingWeight': 100.0,
        'height': 150.0,
        'birthday': date1,
      });

      DocumentSnapshot<Map<String, dynamic>> test1 = await firestore.collection('users').doc(uid).get();
      DocumentSnapshot<Map<String, dynamic>> test2 = await firestore.collection('patients').doc(uid).get();

      when(userRepository.getUser(uid)).thenAnswer((realInvocation) async =>
          UserModel.fromDocument(test1)
      );

      when(patientRepository.getPatient(uid)).thenAnswer((realInvocation) async =>
          PatientModel.fromDocument(test2)
      );

      WriteBatch batch = firestore.batch();
       batch.set(firestore.collection('applications')
          .doc('test'), {
        'user': uid,
        'firstName': 'newFirstName',
        'lastName': 'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'state': "Pending",
        'date': DateTime.timestamp(),
      });

      when(applicationRepository.createApplication(any, uid, 'newFirstName', 'newLastName', 'newGender', 'newMedicalCondition', 100.0, 150.0, date1, 'newObjectives', 'newType')).thenAnswer((realInvocation) async =>
          batch
      );

      expect(await controller.createApplication('newObjectives', 'newType'),
        null
      );

      DocumentSnapshot<Map<String, dynamic>> snap = await firestore.collection('applications').doc('test').get();
      expect(snap.data()!['state'], 'Pending');


    });

    test('CreateApplication catches exception and returns empty statement', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);

      ApplicationsController controller = ApplicationsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryPatient: patientRepository,
          repositoryAppointedMeal: appointedMealRepository, repositoryApplication: applicationRepository,
          repositoryMessages: messageRepository, repositoryDiets: dietRepository);


      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));

      expect(await controller.createApplication('newObjectives', 'newType'),'error');
    });

    test('cancelApplication deletes correctly', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      ApplicationsController controller = ApplicationsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryPatient: patientRepository,
          repositoryAppointedMeal: appointedMealRepository, repositoryApplication: applicationRepository,
          repositoryMessages: messageRepository, repositoryDiets: dietRepository);

      DateTime date1 = DateTime.now();

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('applications')
          .doc('test'), {
        'user': uid,
        'firstName': 'newFirstName',
        'lastName': 'newLastName',
        'gender': 'newGender',
        'medicalCondition': 'newMedicalCondition',
        'weight': 100.0,
        'height': 150.0,
        'birthday': date1,
        'objectives': 'newObjectives',
        'type': 'newType',
        'state': "Pending",
        'date': DateTime.timestamp(),
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

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      for(int i = 0; i < 21; i++) {
        firestore.collection('appointedMeals').doc('$i').set({'patient': uid,'appointedDate': focusedDay, 'followedCorrectly':true});
        firestore.collection('chatrooms').doc('$uid$uid').collection('messages').doc('$i').set({'toId': uid});
      }

      WriteBatch batch2 = firestore.batch();
      batch2.delete(firestore.collection('applications')
          .doc('test'));
      batch2.delete(firestore.collection('diets')
          .doc('test'));
      QuerySnapshot<Map<String, dynamic>> docs = await firestore.collection('appointedMeals').where('patient', isEqualTo: uid).get();
      for(DocumentSnapshot docu in docs.docs) {
        batch2.delete(firestore.collection('appointedMeals')
            .doc(docu.id));
      }
      for(DocumentSnapshot docu in docs.docs) {
        batch2.delete(firestore.collection('chatrooms').doc('$uid$uid').collection('messages').doc(docu.id));
      }
      batch2.delete(firestore.collection('chatrooms').doc('$uid$uid'));


      when(applicationRepository.deleteApplication(any, 'test')).thenAnswer((realInvocation) async =>
      batch2
      );
      when(dietRepository.deleteDiet(any, 'test')).thenAnswer((realInvocation) async =>
      batch2
      );
      when(appointedMealRepository.deleteAllUserMeals(any, uid, true)).thenAnswer((realInvocation) async =>
      batch2
      );
      when(messageRepository.deleteAllUserMessages(any, "$uid$uid")).thenAnswer((realInvocation) async =>
      batch2
      );



      DocumentSnapshot<Map<String, dynamic>> snap = await firestore.collection('applications').doc('test').get();
      expect(snap.data()!['user'], uid);
      DocumentSnapshot<Map<String, dynamic>> snap2 = await firestore.collection('diets').doc('test').get();
      expect(snap2.data()!['patient'], uid);
      DocumentSnapshot<Map<String, dynamic>> snap3 = await firestore.collection('appointedMeals').doc('1').get();
      expect(snap3.data()!['patient'], uid);
      DocumentSnapshot<Map<String, dynamic>> snap4 = await firestore.collection('chatrooms').doc('$uid$uid').collection('messages').doc('1').get();
      expect(snap4.data()!['toId'], uid);

      expect(await controller.cancelApplication('test', {
        'uid': 'test',
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
      }),
          null
      );


      DocumentSnapshot<Map<String, dynamic>> snap5 = await firestore.collection('applications').doc('test').get();
      expect(snap5.data(), null);
      DocumentSnapshot<Map<String, dynamic>> snap6 = await firestore.collection('diets').doc('test').get();
      expect(snap6.data(), null);
      DocumentSnapshot<Map<String, dynamic>> snap7 = await firestore.collection('appointedMeals').doc('1').get();
      expect(snap7.data(), null);
      DocumentSnapshot<Map<String, dynamic>> snap8 = await firestore.collection('chatrooms').doc('$uid$uid').collection('messages').doc('1').get();
      expect(snap8.data(), null);



    });

    test('cancelApplication catches exception and returns empty statement', () async {
      await auth.signInWithCustomToken('some token');
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      String uid = auth.currentUser!.uid;

      ApplicationsController controller = ApplicationsController(db: firestore, auth: authService, file: fileService,
          repositoryUser: userRepository, repositoryPatient: patientRepository,
          repositoryAppointedMeal: appointedMealRepository, repositoryApplication: applicationRepository,
          repositoryMessages: messageRepository, repositoryDiets: dietRepository);

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));

      expect(await controller.cancelApplication(uid, {}),'error');
    });

  });
}