import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:happ_eats/services/file_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';


import 'package:mock_exceptions/mock_exceptions.dart';

import '../controllers/dish_controller_test.mocks.dart';


@GenerateNiceMocks([MockSpec<AuthService>()])

void main() {

  final MockFirebaseStorage storage = MockFirebaseStorage();
  final MockAuthService authService = MockAuthService();
  final MockFirebaseAuth auth = MockFirebaseAuth();
  final imageTestFile = 'assets/images/gochujang.jpg';

  group('Test File Service', ()  {

    test('Test uploadImageFile uploads correctly', () async  {

      await auth.signInWithCustomToken('some token');
      final fileService = FileService(storage: storage, auth: authService);



      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);
      

      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult pepe =  FilePickerResult([platformFile]);
      
      await fileService.uploadImageFile(pepe, 'name');
      
      Map p = storage.storedFilesMap;
      
      expect(p.values.single.toString(), 'File: \'assets/images/gochujang.jpg\'');


    });

    test('Test uploadImageFile launches exception on failure', () async  {


      await auth.signInWithCustomToken('some token');

      final fileService = FileService(storage: storage, auth: authService);

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));

      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult pepe =  FilePickerResult([platformFile]);

      Map p = storage.storedFilesMap;

      expect(await fileService.uploadImageFile(pepe, 'name'), throwsException);

    });

    test('Test uploadDietFile uploads correctly', () async  {


      await auth.signInWithCustomToken('some token');

      final fileService = FileService(storage: storage, auth: authService);


      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);


      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult pepe =  FilePickerResult([platformFile]);

      await fileService.uploadDietFile(pepe);

      Map p = storage.storedFilesMap;

      expect(p.values.single.toString(), 'File: \'assets/images/gochujang.jpg\'');


    });

    test('Test uploadDietFile launches exception on failure', () async  {


      await auth.signInWithCustomToken('some token');

      final fileService = FileService(storage: storage, auth: authService);

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));

      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult pepe =  FilePickerResult([platformFile]);

      Map p = storage.storedFilesMap;

      expect(fileService.uploadDietFile(pepe), throwsException);

    });

    test('Test deleteFile deletes correctly', () async  {


      await auth.signInWithCustomToken('some token');

      final fileService = FileService(storage: storage, auth: authService);


      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);


      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult file =  FilePickerResult([platformFile]);

      File c = File(file.files.single.path.toString());
      String fileName = file.names.toString();

      Reference ref = storage.ref().child("users").child(auth.currentUser!.uid.toString()).child('diet').child(fileName);

      final task = ref.putFile(c);
      await task;

      await fileService.deleteFile(fileName);

      Map p = storage.storedFilesMap;

      expect(p, {});

    });

    test('Test deleteFile launches exception on failure', () async  {


      await auth.signInWithCustomToken('some token');

      final fileService = FileService(storage: storage, auth: authService);

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));


      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult file =  FilePickerResult([platformFile]);

      File c = File(file.files.single.path.toString());
      String fileName = file.names.toString();

      expect( await fileService.deleteFile(fileName), 'error');

    });

    /*test('Test deleteImage deletes correctly', () async  {


      await auth.signInWithCustomToken('some token');

      final fileService = FileService(storage: storage, auth: authService);


      when(authService.getCurrentUser()).thenAnswer((realInvocation) => auth.currentUser);


      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult file =  FilePickerResult([platformFile]);

      File c = File(file.files.single.path.toString());
      String fileName = file.names.toString();

      Reference ref = storage.ref().child("users").child(auth.currentUser!.uid.toString()).child('diet').child(fileName);

      final task = ref.putFile(c);
      await task;

      String name = await ref.getDownloadURL();

      await fileService.deleteImage(name);

      Reference erence = storage.refFromURL(name);

      print(storage.storedFilesMap.toString());

      print(await erence.name);
      print(await ref.name);

     print(storage.storedFilesMap.toString());

      Map p = storage.storedFilesMap;

      expect(p, {});


    });

    test('Test deleteImage launches exception on failure', () async  {


      await auth.signInWithCustomToken('some token');

      final fileService = FileService(storage: storage, auth: authService);

      when(authService.getCurrentUser()).thenAnswer((realInvocation) => throw FirebaseException(plugin: 'ye', message: 'error'));


      final imageFile = File(imageTestFile);
      final bytes = imageFile.readAsBytesSync();
      final readStream = imageFile.openRead();

      final platformFile = PlatformFile(name: 'gochujang.jpg', size: await imageFile.length(), bytes: bytes, readStream: readStream, path: imageTestFile);

      FilePickerResult file =  FilePickerResult([platformFile]);

      File c = File(file.files.single.path.toString());
      String fileName = file.names.toString();

      Reference ref = storage.ref().child("users").child(auth.currentUser!.uid).child('diet').child(fileName);

      Map p = storage.storedFilesMap;

      String name = await ref.getDownloadURL();


      whenCalling(Invocation.method(#refFromURL, null))
          .on(storage)
          .thenThrow(FirebaseAuthException(code: 'bla'));

      expect( () => fileService.deleteImage(name), throwsException );

    });*/

  });
}