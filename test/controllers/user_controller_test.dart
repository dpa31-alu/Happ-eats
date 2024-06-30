
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/controllers/diet_controller.dart';
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
  final MockMessageRepository messageRepository = MockMessageRepository();
  final MockApplicationRepository applicationRepository = MockApplicationRepository();
  final MockDietRepository dietRepository = MockDietRepository();



  group('Test User Controller', ()  {

    test('getUserData retrieves correctly', () async {
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


  });

}