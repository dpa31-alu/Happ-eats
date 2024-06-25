import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:happ_eats/models/user.dart';
import 'package:happ_eats/services/file_service.dart';

import '../models/dish.dart';

import '../services/auth_service.dart';

class DishesController {

  final FirebaseFirestore db;

  final AuthService auth;

  final FileService file;

  final UserRepository repositoryUser;

  final DishRepository repositoryDish;

  DishesController({required this.db, required this.auth, required this.file, required this.repositoryUser, required this.repositoryDish, });

  Future<String?> createDish(String dishName, String description,
      Map<String, dynamic> nutritionalInfo, FilePickerResult? imageFile, Map<String, dynamic> ingredientes) async {
    try {

      User? currentUser = auth.getCurrentUser();
      WriteBatch batch = db.batch();
      String? result;

      if (imageFile!=null)
        {
          FileService fileService = FileService(storage: FirebaseStorage.instance, auth: auth);
          result = await fileService.uploadImageFile(imageFile,dishName);
        }

      DocumentReference<Map<String, dynamic>> referencia =   db.collection('dishes').doc();

      batch = await repositoryUser.addDishes(batch, referencia.id, currentUser!.uid, dishName);
      batch = await repositoryDish.createDish(batch, referencia.id, currentUser.uid, dishName, description, nutritionalInfo, result ,ingredientes);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<String?> copyDish(String dishName, String description,
      Map<String, dynamic> nutritionalInfo, Map<String, dynamic> ingredientes) async {
    try {

      User? currentUser = auth.getCurrentUser();
      WriteBatch batch = db.batch();
      DocumentReference<Map<String, dynamic>> referencia =   db.collection('dishes').doc();

      batch = await repositoryUser.addDishes(batch, referencia.id, currentUser!.uid, dishName);
      batch = await repositoryDish.createDish(batch, referencia.id, currentUser.uid, dishName, description, nutritionalInfo, null, ingredientes);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> retrieveAllDishesForUser(int amount)  {
    User? currentUser = auth.getCurrentUser();
    if (currentUser != null) {
      return repositoryDish.getAllDishes(amount, currentUser.uid);
    }
    else {
      return repositoryDish.getAllDishes(amount,'');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?>? retrieveDishForUser(String id) async {
    try {
      return await repositoryDish.getDish(id);
    }
    on FirebaseException catch (ex) {
      return null;
    }
  }

  Future<String?> deleteDish(String dishId, String user, String? dishImage)  async {
    try {
      WriteBatch batch = db.batch();
      batch = await repositoryUser.removeDishes(batch, dishId, user);
      batch = await repositoryDish.deleteDish(batch, dishId);
      if (dishImage!=null) {
        String? result = await file.deleteImage(dishImage);
        if (result!=null)
          {
           return result;
          }
      }
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Future<FilePickerResult?> getImage()  async {
    try {
      return await file.getImageFile();
    }
    on FirebaseException {
      return null;
    }

  }

  /*
  Future<String?> getImageURL(String fileName, String user) async {
    try {
      return await file.getDownloadURL(fileName, "users", user);
    }
    on FirebaseException {
      return null;
    }
  }*/

}