

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:happ_eats/models/message.dart';
import 'package:happ_eats/models/patient.dart';

import '../models/appointed_meal.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/file_service.dart';

class ApplicationsController {

  final FirebaseFirestore db;

  final AuthService auth;

  final FileService file;

  final UserRepository repositoryUser;

  final PatientRepository repositoryPatient;

  final MessageRepository repositoryMessages;

  final AppointedMealRepository repositoryAppointedMeal;

  final ApplicationRepository repositoryApplication;

  final DietRepository repositoryDiets;

  ApplicationsController({required this.db, required this.auth, required this.file, required this.repositoryUser, required this.repositoryPatient, required this.repositoryAppointedMeal, required this.repositoryApplication, required this.repositoryMessages, required this.repositoryDiets });

  /// Method for creating an application for a patient.
  /// Requires the objectives and type of the application
  /// Returns a null if it works correctly, a string containing the error message if not
  Future<String?> createApplication(String newObjectives, String newType) async {
    try {
      User? currentUser = auth.getCurrentUser();
      UserModel user = await repositoryUser.getUser(currentUser!.uid);
      PatientModel patient = await repositoryPatient.getPatient(currentUser.uid);
      WriteBatch batch = db.batch();
      batch = await repositoryApplication.createApplication(batch, currentUser.uid, user.firstName, user.lastName,  patient.gender, patient.medicalCondition, patient.weight, patient.height, patient.birthday, newObjectives, newType);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Method for returning all applications for a certain type
  /// Requires the amount and type of the application to be retrieved
  /// Returns a stream containing the data, or containing an error
  Stream<QuerySnapshot<Object?>> getApplicationsByTypeStream(String type, int amount)  {
    return repositoryApplication.getAllApplicationsByType(type, amount);
  }

  /// Method for returning an application for a certain user
  /// Returns a map containing the data, or an empty map
  Stream<Map<String, dynamic>> getApplicationForUserState() {
    User? currentUser = auth.getCurrentUser();
    if (currentUser!=null) {
      var result = repositoryApplication.getApplicationForUserState(currentUser.uid);
      return result.asStream();
    } else {
      var result = repositoryApplication.getApplicationForUserState("");
      return result.asStream();
    }
  }

  /// Method for deleting a user's application
  /// Requires the id of the application to be deleted and optionally the information of a diet that was connected to it
  /// Returns a null if it worked correctly, or a string containing the error
  Future<String?> cancelApplication(String id, Map<String, dynamic>? diet)  async {
    try {
      User? currentUser = auth.getCurrentUser();
      WriteBatch batch = db.batch();
      batch = await repositoryApplication.deleteApplication(batch, id);
      if(diet!=null&&diet.isNotEmpty)
        {
          if(diet['url']!=null)
            {
              String? result = await file.deleteFile(diet['url'], currentUser!.uid ,diet['professional']);
              if(result != null)
              {
                return result;
              }
            }
          batch = await repositoryDiets.deleteDiet(batch, diet['uid']);
          batch = await repositoryAppointedMeal.deleteAllUserMeals(batch, currentUser!.uid, true);
          List<String> ids = [diet['patient'], diet['professional']];
          ids.sort();
          String messageUid = ids.join();
          batch = await repositoryMessages.deleteAllUserMessages(batch, messageUid);
        }
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

}