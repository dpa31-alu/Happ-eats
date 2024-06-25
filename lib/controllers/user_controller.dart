import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:happ_eats/models/dish.dart';
import 'package:happ_eats/models/message.dart';
import 'package:happ_eats/models/patient.dart';
import 'package:happ_eats/models/professional.dart';
import 'package:happ_eats/services/auth_service.dart';

import '../models/appointed_meal.dart';
import '../models/user.dart';
import '../services/file_service.dart';

class UsersController {

  final FirebaseFirestore db;

  final AuthService auth;

  late final repositoryUser = UserRepository(db: db);

  late final repositoryProfessional = ProfessionalRepository(db: db);

  late final repositoryMessages = MessageRepository(db: db);

  late final repositoryPatient = PatientRepository(db: db);

  late final repositoryDish = DishRepository(db: db);

  late final repositoryAppointedMeal = AppointedMealRepository(db: db);

  late final repositoryApplication = ApplicationRepository(db: db);

  late final repositoryDiets = DietRepository(db: db);

  UsersController({required this.db, required this.auth});

  Future<String?> createUserPatient(String email, String password, String tel,
      String firstName, String lastName, String birthday,
      String gender, String medicalCondition, String weight, String height)  async{

    WriteBatch batch = db.batch();
    try {
      UserCredential user = await auth.createUser(email, password);
      batch = await repositoryUser.createUser(batch, user.user!.uid, firstName, lastName, tel, gender);
      batch = await repositoryPatient.createPatient(batch, user.user!.uid,gender, medicalCondition, weight, height, birthday);
      await batch.commit();
    } on FirebaseAuthException catch (ex) {
      User? user = auth.getCurrentUser();
      if (user!=null)
        {
          await  auth.deleteUser(user.uid);
        }
        return ex.message;
    }
    on FirebaseException catch (ex) {
        User? user =  auth.getCurrentUser();
        await auth.deleteUser(user!.uid);
        return ex.message;
    }
    return null;
  }

  /*
   Future<String?> updateUserPatient(String tel,
      String firstName, String lastName, String birthday,
      String gender, String medicalCondition, String weight, String height)  async{

    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await UserModel.updateUserInfo(batch, user!.uid, firstName, lastName, tel, gender);
      batch = await PatientModel.updatePatient(batch, user.uid, gender, medicalCondition, weight, height, birthday);
      batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }*/

  Future<String?> updateUserTel(String tel)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryUser.updateUserTel(batch, user!.uid, tel);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> updateUserFirstName(String firstName, bool diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryUser.updateUserFirstName(batch, user!.uid, firstName);

      if(diet){
        batch = await repositoryDiets.updateDietFirstName(batch, user.uid, firstName);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> updateUserLastName(String lastName, bool diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryUser.updateUserLastName(batch, user!.uid,lastName,);

      if(diet){
        batch = await repositoryDiets.updateDietLastName(batch, user.uid, lastName);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> updatePatientGender(String gender, bool diet, bool isPatient)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryUser.updateUserGender(batch, user!.uid, gender);

      if(isPatient) {
        batch = await repositoryPatient.updatePatientGender(batch, user.uid, gender);
      }

      if(diet){
        batch = await repositoryDiets.updateDietGender(batch, user.uid, gender);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> updatePatientMedicalCondition(String medicalCondition, bool diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryPatient.updatePatientMedicalCondition(batch, user!.uid,  medicalCondition,);

      if(diet){
        batch = await repositoryDiets.updateDietMedicalCondition(batch, user.uid, medicalCondition);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> updatePatientWeight(String weight, bool diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryPatient.updatePatientWeight(batch, user!.uid, weight);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> updatePatientHeight(String height, bool diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryPatient.updatePatientHeight(batch, user!.uid, height);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> updatePatientBirthday(String birthday, bool diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryPatient.updatePatientBirthday(batch, user!.uid, birthday);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

   Future<String?> deleteUserPatient()  async{

    WriteBatch batch = db.batch();
    try {
      User? user = auth.getCurrentUser();

      Map<String, dynamic> application = await repositoryApplication.getApplicationForUserState(user!.uid);

      if(application['user']!=null) {
        batch = await repositoryApplication.deleteApplication(batch, user.uid);
        Map<String, dynamic> diet = await repositoryDiets.getDietForUser(user.uid);
        if(diet['patient']!=null) {
          if(diet['url']!=null)
            {
              FileService fileService = FileService(storage: FirebaseStorage.instance, auth: auth);
              String? result = await fileService.deleteFile(diet['url']);
              if(result != null)
              {
                return result;
              }
            }
          batch = await repositoryDiets.deleteDiet(batch, diet['uid']);
          batch = await repositoryAppointedMeal.deleteAllUserMeals(batch, user.uid);
          List<String> ids = [diet['patient'], diet['professional']];
          ids.sort();
          String messageUid = ids.join();
          batch = await repositoryMessages.deleteAllUserMessages(batch, messageUid);

        }
      }
      QuerySnapshot query = await repositoryDish.getAllDishesFuture(user.uid);
      for(DocumentSnapshot docu in query.docs) {
        FileService fileService = FileService(storage: FirebaseStorage.instance, auth: auth);
        String? resultImage = await fileService.deleteImage(docu['image']);
        if (resultImage!=null)
        {
          return resultImage;
        }
         batch.delete(db.collection('dishes')
            .doc(docu.id));
      }
      batch = await repositoryUser.deleteUser(batch, user.uid);
      batch = await repositoryPatient.deletePatient(batch, user.uid);
      await auth.deleteUser(user.uid);
      await batch.commit();
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

   Future<String?> createUserProfessional(String email, String password, String tel,
      String firstName, String lastName, String collegeNumber, String gender) async {
      WriteBatch batch = db.batch();
      try {
        UserCredential user = await auth.createUser(email, password);
        batch = await repositoryUser.createUser(batch, user.user!.uid, firstName, lastName, tel, gender);
        batch = await repositoryProfessional.createProfessional(batch, user.user!.uid, collegeNumber);
        await batch.commit();
      } on FirebaseAuthException catch (ex) {
        User? user = auth.getCurrentUser();
        if (user!=null)
        {
          auth.deleteUser(user.uid);
        }
        return ex.message;
      }
      on FirebaseException catch (ex) {
        User? user = auth.getCurrentUser();
        await auth.deleteUser(user!.uid);
        return ex.message;
      }
      return null;
  }

   Future<String?> deleteUserProfessional()  async{

     WriteBatch batch = db.batch();
     try {
       User? user = auth.getCurrentUser();



         QuerySnapshot<Map<String, dynamic>> diets = await repositoryDiets.getAllDietsForProfessional(user!.uid);

         for (DocumentSnapshot docu in diets.docs)
           {
               if(docu['url']!=null)
               {
                 FileService fileService = FileService(storage: FirebaseStorage.instance, auth: auth);
                 String? result = await fileService.deleteFile(docu['url']);
                 if(result != null)
                 {
                   return result;
                 }
               }
               batch = await repositoryDiets.deleteDiet(batch, docu['uid']);
               batch = await repositoryAppointedMeal.deleteAllUserMeals(batch, docu['patient']);
               List<String> ids = [docu['patient'], docu['professional']];
               ids.sort();
               String messageUid = ids.join();
               batch = await repositoryMessages.deleteAllUserMessages(batch, messageUid);

           }

       QuerySnapshot query = await repositoryDish.getAllDishesFuture(user.uid);
       for(DocumentSnapshot docu in query.docs) {
         FileService fileService = FileService(storage: FirebaseStorage.instance, auth: auth);
         String? resultImage = await fileService.deleteImage(docu['image']);
         if (resultImage!=null)
         {
           return resultImage;
         }
         batch.delete(db.collection('dishes')
             .doc(docu.id));
       }
       batch = await repositoryUser.deleteUser(batch, user.uid);
       batch = await repositoryProfessional.deleteProfessional(batch, user.uid);
       await auth.deleteUser(user.uid);
       await batch.commit();
     } on FirebaseAuthException catch (ex) {
       return ex.message;
     }
     on FirebaseException catch (ex) {
       return ex.message;
     }
     return null;

  }


   Stream<bool> isPatient(String uid) {
     return repositoryPatient.isPatient(uid).asStream();
   }

  Future<String?> loginUser(String email, String password)  async{
    try {
       await auth.login(email, password);
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> logoutUser()  async{
    try {
       await auth.logout();
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
    return null;
  }

  String? getCurrentUserUid()  {
    try {
       User? user =  auth.getCurrentUser();
       if(user!= null) {
         return user.uid;
       }
       else{
         return null;
       }
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserNames()  async {
    try {
      User? user =  auth.getCurrentUser();
      UserModel model = await repositoryUser.getUser(user!.uid);
      Map<String, dynamic> result = {};
      result['firstName'] = model.firstName;
      result['lastName'] = model.lastName;
      result['gender'] = model.gender;
      return result;
    } on FirebaseAuthException {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDishes() async {
    try {
      User? user =  auth.getCurrentUser();
      UserModel dishes = await repositoryUser.getUser(user!.uid);
      return dishes.dishes;
    } on FirebaseAuthException {
      return null;
    }
  }

  Stream<UserModel> getUserData()  {
    User? user =  auth.getCurrentUser();
    Future<UserModel> userData =repositoryUser.getUser(user!.uid);
    return userData.asStream();
  }


  Stream<PatientModel> getPatientData()  {
    User? user =  auth.getCurrentUser();
    Future<PatientModel> userData = repositoryPatient.getPatient(user!.uid);
    return userData.asStream();
  }

  double calculateBMI(double height, double weight) {
    return (weight/(height*height));
  }

}