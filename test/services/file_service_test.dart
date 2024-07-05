import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:happ_eats/services/file_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';




import '../controllers/dish_controller_test.mocks.dart';


@GenerateNiceMocks([MockSpec<AuthService>()])

void main() {

   MockFirebaseStorage storage = MockFirebaseStorage();
  final MockAuthService authService = MockAuthService();
  final MockFirebaseAuth auth = MockFirebaseAuth();
  const imageTestFile = 'assets/images/gochujang.jpg';

  setUp(() => storage = MockFirebaseStorage());

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


      expect(()=> fileService.uploadImageFile(pepe, 'name'), throwsException);

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

      await fileService.uploadDietFile(pepe, 'uid');

      Map p =  storage.storedFilesMap;

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


      expect(fileService.uploadDietFile(pepe, 'uid'), throwsException);

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

      Reference ref = storage.ref().child("users").child(auth.currentUser!.uid.toString()).child('diet').child(auth.currentUser!.uid.toString()).child(fileName);

      final task = ref.putFile(c);
      await task;

      await fileService.deleteFile(fileName, auth.currentUser!.uid.toString(), auth.currentUser!.uid.toString());

      Map p = storage.storedFilesMap;

      expect(p, {});

    });

  });
}