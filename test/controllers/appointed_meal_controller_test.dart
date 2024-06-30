import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:happ_eats/controllers/appointed_meal_controller.dart';


import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/models/appointed_meal.dart';
import 'package:happ_eats/models/dish.dart';




import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


import 'appointed_meal_controller_test.mocks.dart';


@GenerateNiceMocks([MockSpec<AppointedMealRepository>()])
@GenerateNiceMocks([MockSpec<DishRepository>()])


void main()  {


  group('Test AppointedMeal Controller', ()   {


    test('retrieveAllDishesForUser retrieves correctly', () async {

      MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
      MockDishRepository dishRepository = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      AppointedMealsController controller = AppointedMealsController(db: firestore, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      for(int i = 0; i < 21; i++) {
        firestore.collection('appointedMeals').doc().set({'patient': uid,'appointedDate': focusedDay, 'followedCorrectly':true});
      }
      DateTime date = DateTime.now();
      firestore.collection('appointedMeals').doc().set({'patient': uid,'appointedDate': date, 'followedCorrectly':true});

      when(appointedMealRepository.getAllAppointmentsForToday(any, any)).thenAnswer((realInvocation) => firestore.collection('appointedMeals').where('patient', isEqualTo: uid)
          .where('appointedDate', isEqualTo: focusedDay).where('followedCorrectly', isEqualTo: true).snapshots());


      controller.retrieveAllDishesForUser(uid,  focusedDay).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 21);
        expect(snap.docChanges.first.doc.data(), {
        'patient': uid,
        'appointedDate': Timestamp.fromDate(focusedDay),
        'followedCorrectly': true
        } );
      }));

    });

    test('retrieveAllDishesForUserStream retrieves correctly and the right amount', () async {

      MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
      MockDishRepository dishRepository = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      AppointedMealsController controller = AppointedMealsController(db: firestore, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      DateTime focusedDay2 = DateTime.utc(DateTime.now().year, DateTime.now().month-1, DateTime.now().day);

      DateTime fakeDay = DateTime.utc(DateTime.now().year-1, DateTime.now().month, DateTime.now().day);

      for(int i = 0; i < 21; i++) {
        await firestore.collection('appointedMeals').doc().set({'diet': uid, 'patient': uid, 'professional': uid, 'appointedDate': focusedDay, 'followedCorrectly':true});
      }
      for(int i = 0; i < 21; i++) {
       await firestore.collection('appointedMeals').doc().set({'diet': uid, 'patient': uid, 'professional': uid, 'appointedDate': fakeDay, 'followedCorrectly':true});
      }

      when(appointedMealRepository.getAllAppointmentsStream(any, any, any, any)).thenAnswer((realInvocation) => firestore.collection('appointedMeals').where('diet', isEqualTo: uid)
          .where('appointedDate', isGreaterThanOrEqualTo: focusedDay2).where('appointedDate', isLessThanOrEqualTo: focusedDay).snapshots());


      controller.retrieveAllDishesForUserStream(focusedDay2,  focusedDay, uid, uid).listen(expectAsync1 ((snap) {
        expect(snap.docChanges.length, 21);
      }));

    });



    test('createAppointment creates correctly', () async {

      MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
      MockDishRepository dishRepository = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();


      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      AppointedMealsController controller = AppointedMealsController(db: firestore, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      WriteBatch batch =  firestore.batch();

      String id = "${focusedDay.day}-${focusedDay.month}-${focusedDay.year}_${'diet'}_${1.toString()}";

      batch.set(firestore.collection('appointedMeals')
          .doc(id), {
        'alternativeRequired': false,
        'diet': 'diet',
        'professional': 'professional',
        'patient': 'patient',
        'appointedDate': focusedDay,
        'dish': 'dish',
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1
      },
      );

      firestore.collection('dishes').doc(uid).set({'nutritionalInfo': {'calories':200.0}});

      when(appointedMealRepository.createAppointedMeal(any, any, any, any, any, any, any, any, any, any)).thenAnswer((realInvocation) async => batch);

      when(dishRepository.getDish(any)).thenAnswer((realInvocation) async => await firestore.collection('dishes').doc(uid).get());

      expect(await controller.createAppointment('dishName', 'dish', 'diet', 'professional', 'patient', focusedDay, 1), null);

      DocumentSnapshot<Map<String, dynamic>> p = await firestore.collection('appointedMeals')
          .doc(id).get();

      expect(p.data()!['diet'], 'diet');

    });

    test('createAppointment catches exception and returns ', () async {

      MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
      MockDishRepository dishRepository = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();


      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      AppointedMealsController controller = AppointedMealsController(db: firestore, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      WriteBatch batch =  firestore.batch();

      String id = "${focusedDay.day}-${focusedDay.month}-${focusedDay.year}_${'diet'}_${1.toString()}";

      batch.set(firestore.collection('appointedMeals')
          .doc(id), {
        'alternativeRequired': false,
        'diet': 'diet',
        'professional': 'professional',
        'patient': 'patient',
        'appointedDate': focusedDay,
        'dish': 'dish',
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1
      },
      );

      firestore.collection('dishes').doc(uid).set({'nutritionalInfo': {'calories':200.0}});

      when(appointedMealRepository.createAppointedMeal(any, any, any, any, any, any, any, any, any, any)).thenAnswer((realInvocation) async => throw FirebaseException(plugin: 'ye', message: 'Error'));

      when(dishRepository.getDish(any)).thenAnswer((realInvocation) async => await firestore.collection('dishes').doc(uid).get());

      expect(await controller.createAppointment('dishName', 'dish', 'diet', 'professional', 'patient', focusedDay, 1), 'Error');

    });

    test('confirmConsumption updates correctly', () async {

      MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
      MockDishRepository dishRepository = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();


      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      AppointedMealsController controller = AppointedMealsController(db: firestore, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      WriteBatch batch =  firestore.batch();

      String id = "${focusedDay.day}-${focusedDay.month}-${focusedDay.year}_${'diet'}_${1.toString()}";

      await firestore.collection('appointedMeals').doc(id).set({'alternativeRequired': false,
        'diet': 'diet',
        'professional': 'professional',
        'patient': 'patient',
        'appointedDate': focusedDay,
        'dish': 'dish',
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1,});

      batch.update(firestore.collection('appointedMeals')
          .doc(id), {
        'followedCorrectly': true,
      },
      );

      firestore.collection('dishes').doc(uid).set({'nutritionalInfo': {'calories':200.0}});

      when(appointedMealRepository.consumedCorrectlyAppointedMeal(any, any)).thenAnswer((realInvocation) async => batch);

      expect(await controller.confirmConsumption(id), null);

      DocumentSnapshot<Map<String, dynamic>> p = await firestore.collection('appointedMeals')
          .doc(id).get();

      expect(p.data()!['followedCorrectly'], true);

    });

    test('confirmConsumption catches exception correctly', () async {

      MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
      MockDishRepository dishRepository = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();


      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      AppointedMealsController controller = AppointedMealsController(db: firestore, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      WriteBatch batch =  firestore.batch();

      String id = "${focusedDay.day}-${focusedDay.month}-${focusedDay.year}_${'diet'}_${1.toString()}";

      await firestore.collection('appointedMeals').doc(id).set({'alternativeRequired': false,
        'diet': 'diet',
        'professional': 'professional',
        'patient': 'patient',
        'appointedDate': focusedDay,
        'dish': 'dish',
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1,});

      batch.update(firestore.collection('appointedMeals')
          .doc(id), {
        'followedCorrectly': true,
      },
      );

      firestore.collection('dishes').doc(uid).set({'nutritionalInfo': {'calories':200.0}});

      when(appointedMealRepository.consumedCorrectlyAppointedMeal(any, any)).thenAnswer((realInvocation) async => throw FirebaseException(plugin: 'ye', message: 'Error'));

      expect(await controller.confirmConsumption(id), 'Error');

    });

    test('writeNote updates correctly', () async {

      MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
      MockDishRepository dishRepository = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();


      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      AppointedMealsController controller = AppointedMealsController(db: firestore, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      WriteBatch batch =  firestore.batch();

      String id = "${focusedDay.day}-${focusedDay.month}-${focusedDay.year}_${'diet'}_${1.toString()}";

      await firestore.collection('appointedMeals').doc(id).set({'alternativeRequired': false,
        'diet': 'diet',
        'professional': 'professional',
        'patient': 'patient',
        'appointedDate': focusedDay,
        'dish': 'dish',
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1,});

      batch.update(firestore.collection('appointedMeals')
          .doc(id),
        {
          'alternativeRequired': true,
          'note': 'note',
        },
      );

      firestore.collection('dishes').doc(uid).set({'nutritionalInfo': {'calories':200.0}});

      when(appointedMealRepository.signalIssuesAppointedMeal(any, any, any)).thenAnswer((realInvocation) async => batch);

      expect(await controller.writeNote(id, 'note'), null);

      DocumentSnapshot<Map<String, dynamic>> p = await firestore.collection('appointedMeals')
          .doc(id).get();

      expect(p.data()!['note'], 'note');

    });

    test('writeNote catches exception correctly', () async {

      MockAppointedMealRepository appointedMealRepository = MockAppointedMealRepository();
      MockDishRepository dishRepository = MockDishRepository();

      MockFirebaseAuth auth = MockFirebaseAuth();


      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;

      AppointedMealsController controller = AppointedMealsController(db: firestore, repositoryDish: dishRepository, repositoryAppointedMeal: appointedMealRepository);

      DateTime focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      WriteBatch batch =  firestore.batch();

      String id = "${focusedDay.day}-${focusedDay.month}-${focusedDay.year}_${'diet'}_${1.toString()}";

      await firestore.collection('appointedMeals').doc(id).set({'alternativeRequired': false,
        'diet': 'diet',
        'professional': 'professional',
        'patient': 'patient',
        'appointedDate': focusedDay,
        'dish': 'dish',
        'dishName': 'dishName',
        'values': {},
        'mealOrder': 1,});

      batch.update(firestore.collection('appointedMeals')
          .doc(id), {
        'followedCorrectly': true,
      },
      );

      firestore.collection('dishes').doc(uid).set({'nutritionalInfo': {'calories':200.0}});

      when(appointedMealRepository.signalIssuesAppointedMeal(any, any, any)).thenAnswer((realInvocation) async => throw FirebaseException(plugin: 'ye', message: 'Error'));

      expect(await controller.writeNote(id, 'Note'), 'Error');

    });

  });



}