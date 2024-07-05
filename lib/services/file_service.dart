import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:happ_eats/services/auth_service.dart';

class FileService {

  final FirebaseStorage storage;

  final AuthService auth;

  FileService({required this.storage, required this.auth});

  /// Obtains an image file from the terminal
  Future<FilePickerResult?> getImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['png' , 'jpg'],
    );

    return result;
  }

  /// Obtains a diet file from the terminal
  Future<FilePickerResult?> getDietFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );

    return result;
  }

  /// Generates a random string to avoid duplicated names deleting each other on update
  String generateRandomString(int len) {
    var r = Random.secure();
    String randomString = String.fromCharCodes(List.generate(len, (index)=> r.nextInt(33) + 89));
    return randomString;
  }

  /// Uploads the image of a dish
  /// Requires the file and the name
  /// Returns the downloadUrl
   Future<String> uploadImageFile(FilePickerResult file, String name) async {

     File c = File(file.files.single.path.toString());

     String safety = generateRandomString(10);

     String fileName = ("${file.names.toString()}-$name-$safety");

     Reference fileDirection = storage.ref().child("users").child(auth.getCurrentUser()!.uid.toString()).child('dishes').child(fileName);
     UploadTask task = fileDirection.putFile(c);
     await task;
     return fileDirection.getDownloadURL();
  }

  /// Gets the download link of a diet file
  /// Requires the name of the filem professional and patient
  /// Returns a string containing the url or an error
   Future<String?> downloadDietFile(String fileName, String professional, String patient) async {
    try {
      return await storage.ref().child("users").child(professional).child('diets').child(patient).child(fileName).getDownloadURL();
    } on FirebaseException catch (ex) {
      return ex.message;
    }
  }

  /// Uploads the file of a diet
  /// Requires the file and the patient
  /// Returns null, or a string containing an error
   Future<String?> uploadDietFile(FilePickerResult file, String patient) async {

    File c = File(file.files.single.path.toString());
    String fileName = "dieta.pdf";


    Reference fileDirection = storage.ref().child("users").child(auth.getCurrentUser()!.uid.toString()).child('diets').child(patient).child(fileName);
    UploadTask task = fileDirection.putFile(c);
    await task;
    return fileName;
  }

  /// Deletes the file of a diet
  /// Requires the name of the file
  /// Returns null, or a string containing an error
   Future<String?> deleteFile(String fileName, String userPatient, String userProfessional) async {
    try {
      await storage.ref().child("users").child(userProfessional).child('diets').child(userPatient).child(fileName).delete();
    } on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Deletes the image of a dish
  /// Requires the url of the image
  /// Returns null, or a string containing an error
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