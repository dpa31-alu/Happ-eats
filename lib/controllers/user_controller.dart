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

  /// Creates a patient
  /// Requires the email, password, phone number, first name, last name, birthday, gender, medical conditions, weight and height
  /// Creates the patient, user and authentication
  /// Returns null, or a string with the error
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
        return ex.message;
    }
    on FirebaseException catch (ex) {
        return ex.message;
    }
    return null;
  }

  /// Updates a user's phone number
  /// Requires the phone number
  /// Returns null, or a string with the error
  Future<String?> updateUserTel(String tel)  async{
    try {
      WriteBatch batch = db.batch();
      User? user =  auth.getCurrentUser();
      batch = await repositoryUser.updateUserTel(batch, user!.uid, tel);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Updates a user's first name
  /// Requires the first name and optionally the info of a diet that also needs to be updated
  /// Returns null, or a string with the error
  Future<String?> updateUserFirstName(String firstName, Map diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryUser.updateUserFirstName(batch, user!.uid, firstName);

      if(diet['uid']!=null){
        batch = await repositoryDiets.updateDietFirstName(batch, diet['uid'], firstName);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Updates a patient's last name
  /// Requires the last name and optionally the info of a diet that also needs to be updated
  /// Returns null, or a string with the error
  Future<String?> updateUserLastName(String lastName, Map diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryUser.updateUserLastName(batch, user!.uid,lastName,);

      if(diet['uid']!=null){
        batch = await repositoryDiets.updateDietLastName(batch, diet['uid'], lastName);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Updates a user's gender
  /// Requires the gender and optionally the info of a diet that also needs to be updated. Also requires to know if the user is a patient
  /// Returns null, or a string with the error
  Future<String?> updatePatientGender(String gender, Map diet, bool isPatient)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryUser.updateUserGender(batch, user!.uid, gender);

      if(isPatient) {
        batch = await repositoryPatient.updatePatientGender(batch,  user.uid, gender);
      }

      if(diet['uid']!=null){
        batch = await repositoryDiets.updateDietGender(batch,  diet['uid'], gender);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Updates a patient's medical condition
  /// Requires the medical condition and optionally the info of a diet that also needs to be updated
  /// Returns null, or a string with the error
  Future<String?> updatePatientMedicalCondition(String medicalCondition,  Map diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryPatient.updatePatientMedicalCondition(batch, user!.uid,  medicalCondition,);

      if(diet['uid']!=null){
        batch = await repositoryDiets.updateDietMedicalCondition(batch, diet['uid'], medicalCondition);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Updates a patient's weight
  /// Requires the weight and optionally the info of a diet that also needs to be updated
  /// Returns null, or a string with the error
  Future<String?> updatePatientWeight(String weight, Map diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryPatient.updatePatientWeight(batch, user!.uid, weight);

      if(diet['uid']!=null){
        batch = await repositoryDiets.updateDietWeight(batch, diet['uid'], weight);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Updates a patient's height
  /// Requires the height and optionally the info of a diet that also needs to be updated
  /// Returns null, or a string with the error
  Future<String?> updatePatientHeight(String height, Map diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryPatient.updatePatientHeight(batch, user!.uid, height);

      if(diet['uid']!=null){
        batch = await repositoryDiets.updateDietHeight(batch, diet['uid'], height);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Updates a patient's birthday
  /// Requires the birthday and optionally the info of a diet that also needs to be updated
  /// Returns null, or a string with the error
  Future<String?> updatePatientBirthday(String birthday, Map diet)  async{
    WriteBatch batch = db.batch();
    try {
      User? user =  auth.getCurrentUser();
      batch = await repositoryPatient.updatePatientBirthday(batch, user!.uid, birthday);

      if(diet['uid']!=null){
        batch = await repositoryDiets.updateDietBirthday(batch, diet['uid'], birthday);
      }

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Deletes a patient
  /// Deletes the patient, user, application and diet attached to him, every dish, every message and every appointment
  /// Returns null, or a string with the error
   Future<String?> deleteUserPatient()  async{


    try {
      WriteBatch batch = db.batch();
      User? user = auth.getCurrentUser();

      Map<String, dynamic> application = await repositoryApplication.getApplicationForUserState(user!.uid);


      if(application['user']!=null) {

        batch = await repositoryApplication.deleteApplication(batch, application['uid']);
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
        if(docu['image']!=null)
          {
            String? resultImage = await fileService.deleteImage(docu['image']);
            if (resultImage!=null)
            {
              return resultImage;
            }
          }
         batch.delete(db.collection('dishes')
            .doc(docu.id));
      }
      batch = await repositoryUser.deleteUser(batch, user.uid);
      batch = await repositoryPatient.deletePatient(batch, user.uid);
      await batch.commit();
      await auth.deleteUser(user.uid);
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Creates a professional
  /// Requires the email, password, phone number, first name, last name, college number and gender
  /// Creates the professional, user and authentication
  /// Returns null, or a string with the error
   Future<String?> createUserProfessional(String email, String password, String tel,
      String firstName, String lastName, String collegeNumber, String gender) async {
      WriteBatch batch = db.batch();
      try {
        UserCredential user = await auth.createUser(email, password);
        batch = await repositoryUser.createUser(batch, user.user!.uid, firstName, lastName, tel, gender);
        batch = await repositoryProfessional.createProfessional(batch, user.user!.uid, collegeNumber);
        await batch.commit();
      } on FirebaseAuthException catch (ex) {
        return ex.message;
      }
      on FirebaseException catch (ex) {
        return ex.message;
      }
      return null;
  }

  /// Deletes a professional
  /// Deletes the professional, user, every diet attached to them, every dish, every message and every appointment
  /// Returns null, or a string with the error
   Future<String?> deleteUserProfessional()  async{
     try {
       WriteBatch batch = db.batch();
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
       await batch.commit();
       await auth.deleteUser(user.uid);
     } on FirebaseAuthException catch (ex) {
       return ex.message;
     }
     on FirebaseException catch (ex) {
       return ex.message;
     }
     return null;

  }

  /// Returns a bool signaling if the user is a patient or not
  /// Returns true if the user is a patient, or false if they aren't
   Stream<bool> isPatient(String uid) {
     return repositoryPatient.isPatient(uid).asStream();
   }

  /// Logs in the user
  /// Returns null, or a string with the error
  Future<String?> loginUser(String email, String password)  async{
    try {
       await auth.login(email, password);
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Logs out the user
  /// Returns null, or a string with the error
  Future<String?> logoutUser()  async{
    try {
       await auth.logout();
    } on FirebaseAuthException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Retrieves the user uid
  /// Returns a the uid as a string, or null
  String? getCurrentUserUid()  {
       User? user =  auth.getCurrentUser();
       if(user!= null) {
         return user.uid;
       }
       else{
         return null;
       }
  }

  /// Retrieves the patient data as a future
  /// Returns a UserModel object with the data, or null if there is an error
  Future<UserModel>? getUserDataFuture()  {
    try {
      User? user =  auth.getCurrentUser();
      Future<UserModel> userData = repositoryUser.getUser(user!.uid);
      return userData;
    } on FirebaseAuthException {
      return null;
    } on FirebaseException {
      return null;
    } on Exception {
      return null;
    }
  }


  /// Retrieves the user data as a stream
  /// Returns a stream with the data, or null if there is an error
  Stream<UserModel>? getUserData()  {
    try {
      User? user =  auth.getCurrentUser();
      if(user!=null) {
        Future<UserModel> userData = repositoryUser.getUser(user.uid);
        return userData.asStream();
      }
      else {
        return null;
      }
    } on FirebaseAuthException {
      return null;
    } on FirebaseException {
      return null;
    } on Exception {
      return null;
    }
  }


  /// Retrieves the patient data as a stream
  /// Returns a stream with the data, or null if there is an error
  Stream<PatientModel>? getPatientData()  {
    try {
      User? user =  auth.getCurrentUser();
      Future<PatientModel> userData = repositoryPatient.getPatient(user!.uid);
      return userData.asStream();
    } on FirebaseAuthException {
      return null;
    } on FirebaseException {
      return null;
    } on Exception {
      return null;
    }
  }


}