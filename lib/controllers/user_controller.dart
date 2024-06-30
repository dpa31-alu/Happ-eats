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

  final UserRepository repositoryUser ;

  final ProfessionalRepository repositoryProfessional;

  final MessageRepository repositoryMessages;

  final PatientRepository repositoryPatient;

  final DishRepository repositoryDish;

  final AppointedMealRepository repositoryAppointedMeal;

  final ApplicationRepository repositoryApplication;

  final DietRepository repositoryDiets;

  UsersController({
    required this.db,
    required this.auth,
    required this.repositoryUser,
    required this.repositoryProfessional,
    required this.repositoryMessages,
    required this.repositoryPatient,
    required this.repositoryDish,
    required this.repositoryAppointedMeal,
    required this.repositoryApplication,
    required this.repositoryDiets,});

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
       User? user =  auth.getCurrentUser();
       if(user!= null) {
         return user.uid;
       }
       else{
         return null;
       }
  }

  Future<UserModel>? getUserDataFuture()  {
    try {
      User? user =  auth.getCurrentUser();
      Future<UserModel> userData = repositoryUser.getUser(user!.uid);
      return userData;
    } on FirebaseAuthException {
      return null;
    }
  }

  Stream<UserModel>? getUserData()  {
    User? user =  auth.getCurrentUser();
    if(user!=null) {
      Future<UserModel> userData = repositoryUser.getUser(user.uid);
      return userData.asStream();
    }
    else {
      return null;
    }
  }


  Stream<PatientModel> getPatientData()  {
    User? user =  auth.getCurrentUser();
    Future<PatientModel> userData = repositoryPatient.getPatient(user!.uid);
    return userData.asStream();
  }


}