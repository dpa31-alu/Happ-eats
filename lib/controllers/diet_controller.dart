
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:happ_eats/models/application.dart';
import 'package:happ_eats/models/message.dart';
import 'package:happ_eats/services/file_service.dart';


import '../models/diet.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/getChatroomId.dart';

class DietsController {

  final FirebaseFirestore db;

  final AuthService auth;

  final FileService file;

  final UserRepository repositoryUser;

  final MessageRepository repositoryMessages;

  final ApplicationRepository repositoryApplication;

  final DietRepository repositoryDiets;

  DietsController({required this.db, required this.auth, required this.file, required this.repositoryUser, required this.repositoryMessages, required this.repositoryApplication, required this.repositoryDiets});

  Future<String?> createDiet(String patient, String firstName, String lastName,
      String gender, String medicalCondition, double weight, double height, DateTime birthday, String objectives, String type) async {
    try {
      User? currentUser = auth.getCurrentUser();
      UserModel professional = await repositoryUser.getUser(currentUser!.uid);
      String textChain = "Este es un mensaje automatizado para comunicarle que su solicitud ha sido procesada y aceptada por el profesional: ${professional.firstName} ${professional.lastName}";
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

  Future<String?> addFile(String uid, String patient) async {
    try {
      WriteBatch batch = db.batch();
      FilePickerResult? result = await file.getDietFile();
      String? url;
      if (result==null) {
        return 'Seleccione un archivo.';
      }
      else {
         url = await file.uploadDietFile(result, patient);
      }
      batch = await repositoryDiets.addRefApplication(batch, uid, url!);

      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> downloadFile(String fileName, String patient, String professional) async {
    try {
      await file.downloadDietFile(fileName, patient, professional);
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveAllDiets(String type, int amount)  {
    User? currentUser = auth.getCurrentUser();
    if(currentUser!=null) {
        return repositoryDiets.getAllDiets(type, amount, currentUser.uid);
    }
    else {
      return repositoryDiets.getAllDiets(type, amount, '');
    }

  }

  Future<Map<String, dynamic>> retrieveDietForUser()  async {
    Map<String, dynamic> diet = {};
    try {
      User? currentUser = auth.getCurrentUser();
      if (currentUser!=null) {
        diet = await repositoryDiets.getDietForUser(currentUser.uid);
      }
    }
    on FirebaseException {
      return {};
    }
    return diet;
  }

  Stream<Map<String, dynamic>> retrieveDietForUserStream()   {
    User? currentUser = auth.getCurrentUser();
    Future<Map<String, dynamic>> diet;
    if (currentUser!=null) {
      diet =  repositoryDiets.getDietForUser(currentUser.uid);
    } else {
      diet =  Future<Map<String, dynamic>>.value({});
    }
    return diet.asStream();
  }

}