import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:happ_eats/services/auth_service.dart';

class FileService {

  final FirebaseStorage storage;

  final AuthService auth;

  FileService({required this.storage, required this.auth});


  Future<FilePickerResult?> getImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['png' , 'jpg'],
    );

    return result;
  }

  Future<FilePickerResult?> getDietFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );

    return result;
  }

  String generateRandomString(int len) {
    var r = Random.secure();
    String randomString = String.fromCharCodes(List.generate(len, (index)=> r.nextInt(33) + 89));
    return randomString;
  }

   Future<String> uploadImageFile(FilePickerResult file, String name) async {

     File c = File(file.files.single.path.toString());

     String safety = generateRandomString(10);

     String fileName = ("${file.names.toString()}-$name-$safety");

     Reference fileDirection = storage.ref().child("users").child(auth.getCurrentUser()!.uid.toString()).child('dishes').child(fileName);
     UploadTask task = fileDirection.putFile(c);
     await task;
     return fileDirection.getDownloadURL();
  }

   Future<String?> downloadDietFile(String fileName, String professional, String patient) async {
    try {
      return await storage.ref().child("users").child(professional).child('diets').child(patient).child(fileName).getDownloadURL();
    } on FirebaseException catch (ex) {
      return ex.message;
    }
  }

   Future<String?> uploadDietFile(FilePickerResult file, String patient) async {

    File c = File(file.files.single.path.toString());
    String fileName = file.names.toString();

    Reference fileDirection = storage.ref().child("users").child(auth.getCurrentUser()!.uid.toString()).child('diets').child(patient).child(fileName);
    UploadTask task = fileDirection.putFile(c);
    await task;
    return fileName;
  }

  /*
   Future<String?> downloadDietFile(String fileName, String uid) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      const String archivo = "dieta.pdf";

      final File tempFile = File("${appDocDir.absolute.path}/$archivo");

      print(appDocDir.absolute.path);

      TaskSnapshot task = await storage.ref().child("users").child(uid).child('diets').child(auth.getCurrentUser()!.uid.toString()).child(fileName).writeToFile(tempFile);
       task;
       await tempFile.create();
       await OpenFile.open(tempFile.path);

    } on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }*/

   Future<String?> deleteFile(String fileName) async {
    try {
      await storage.ref().child("users").child(auth.getCurrentUser()!.uid.toString()).child('diet').child(fileName).delete();
    } on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }


   Future<String?> deleteImage(String url) async {
    try {
      Reference ref = storage.refFromURL(url);
      await ref.delete();
    } on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

}