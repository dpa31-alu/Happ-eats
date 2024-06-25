import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/src/file_picker_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/diet.dart';
import 'package:happ_eats/services/file_service.dart';

import '../models/message.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/getChatroomId.dart';

class DietsController {

  final FirebaseFirestore db;

  final AuthService auth;

  late final repositoryUser = UserRepository(db: db);

  late final repositoryMessages = MessageRepository(db: db);

  late final repositoryApplication = ApplicationRepository(db: db);

  late final repositoryDiets = DietRepository(db: db);

  DietsController({required this.db, required this.auth});

  Future<String?> createDiet(String patient, String firstName, String lastName,
      String gender, String medicalCondition, double weight, double height, DateTime birthday, String objectives, String type) async {
    try {
      User? currentUser = auth.getCurrentUser();
      UserModel professional = await repositoryUser.getUser(currentUser!.uid);
      String textChain = "Este es un mensaje automatizado para comunicarle que su solicitud ha sido procesada y aceptada por el profesional: " + professional.firstName + " " + professional.lastName;
      WriteBatch batch = db.batch();
      batch = await repositoryApplication.assignApplication(batch, patient);
      batch = await repositoryDiets.createDiet(batch, patient, currentUser.uid, firstName, lastName, gender, medicalCondition, weight, height, birthday, objectives, type);
      String chatroomid = getChatroomId(patient, currentUser.uid);
      batch = await repositoryMessages.sendMessage(batch,chatroomid, patient, currentUser.uid, textChain);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> addFile(String uid) async {
    try {
      WriteBatch batch = db.batch();
      FileService fileService = FileService(storage: FirebaseStorage.instance, auth: auth);
      FilePickerResult? result = await fileService.getDietFile();
      String? url;
      if (result==null) {
        return 'Seleccione un archivo.';
      }
      else {
         url = await fileService.uploadDietFile(result);
      }
      batch = await repositoryDiets.addRefApplication(batch, uid, url!);

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> downloadFile(String uid, String fileName) async {
    try {
      FileService fileService = FileService(storage: FirebaseStorage.instance, auth: auth);
      await fileService.downloadDietFile(fileName, uid);
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveAllDiets(String type, int amount)  {
    User? currentUser = auth.getCurrentUser();
    return repositoryDiets.getAllDiets(type, amount, currentUser!.uid);
  }

  Future<Map<String, dynamic>> retrieveDietForUser()  async {
    User? currentUser = auth.getCurrentUser();
    Map<String, dynamic> diet = await repositoryDiets.getDietForUser(currentUser!.uid);
    return diet;
  }

  Stream<Map<String, dynamic>> retrieveDietForUserStream()   {
    User? currentUser = auth.getCurrentUser();
    Future<Map<String, dynamic>> diet =  repositoryDiets.getDietForUser(currentUser!.uid);
    return diet.asStream();
  }

  /*
  Future<String?> cancelDiet(String? fileName)  async {
    User? currentUser = auth.getCurrentUser();
    try {
      WriteBatch batch = db.batch();
      if (fileName!=null)
        {
          FileService fileService = FileService(storage: FirebaseStorage.instance, auth: auth);

          String? result = await fileService.deleteFile(fileName);

          if(result != null)
            {
              return result;
            }
        }
      batch = await repositoryDiets.deleteDiet(batch, currentUser!.uid);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }*/

}