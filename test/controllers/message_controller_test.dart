import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:happ_eats/controllers/message_controller.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:happ_eats/models/message.dart';



import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


import 'message_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MessageRepository>()])


void main()  {


  group('Test Message Controller', ()   {


    test('SendMessage send message correctly', () async {

      MockMessageRepository messageRepository = MockMessageRepository();

      MockFirebaseAuth _auth = MockFirebaseAuth();


      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;

      MessagesController controller = MessagesController(db: firestore, repositoryMessages: messageRepository,);

      WriteBatch batch =  firestore.batch();

      batch.set(firestore.collection('chatrooms').doc(uid).collection('messages')
          .doc(), {
        'toID':uid,
        'fromID':uid,
        'text':'text',
        'timestamp':DateTime.timestamp()
      });

      when(messageRepository.sendMessage(any, any, any, any, any)).thenAnswer((realInvocation) async => batch);

      expect(await controller.sendMessage('$uid$uid', uid, uid, 'text'), null);

      QuerySnapshot<Map<String, dynamic>> p = await firestore.collection('chatrooms').doc(uid).collection('messages').get();

      expect(p.docs[0].data()['text'], 'text');

      //print(firestore.dump());

    });

    test('Send catches exception and returns text', () async {

      MockMessageRepository messageRepository = MockMessageRepository();

      MockFirebaseAuth _auth = MockFirebaseAuth();


      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;

      MessagesController controller = MessagesController(db: firestore, repositoryMessages: messageRepository,);

      WriteBatch batch =  firestore.batch();

      batch.set(firestore.collection('chatrooms').doc(uid).collection('messages')
          .doc(), {
        'toID':uid,
        'fromID':uid,
        'text':'text',
        'timestamp':DateTime.timestamp()
      });

      when(messageRepository.sendMessage(any, any, any, any, any)).thenAnswer((realInvocation) async => throw FirebaseException(plugin: 'ye', message: 'error'));

      expect(await controller.sendMessage('$uid$uid', uid, uid, 'text'), 'error');

    });

    test('retrieveConversationMessages retrieves the correct amount of messages and in order', () async {

      MockMessageRepository messageRepository = MockMessageRepository();

      MockFirebaseAuth _auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: _auth.authForFakeFirestore);
      await _auth.signInWithCustomToken('some token');
      final uid = _auth.currentUser!.uid;
      //MessageRepository repository = MessageRepository(db: firestore);

      MessagesController controller = MessagesController(db: firestore, repositoryMessages: messageRepository,);


      for(int i = 0; i < 21; i++) {
        firestore.collection('chatrooms').doc(uid).collection('messages').doc().set({'timestamp': Timestamp.fromDate(DateTime.now()),});
      }
      DateTime date = DateTime.now();
      firestore.collection('chatrooms').doc(uid).collection('messages').doc().set({'timestamp': Timestamp.fromDate(date),});


      when(messageRepository.getMessagesForAmount(any, any)).thenAnswer((realInvocation) => firestore.collection('chatrooms').doc(uid).collection('messages').limit(20).orderBy('timestamp', descending: true).snapshots());


      controller.retrieveConversationMessages(20,  uid).listen(expectAsync1 ((snap) {
        expect(snap!.docChanges.length, 20);
        expect(snap.docChanges.first.doc.data(), {'timestamp': Timestamp.fromDate(date),} );
      }));

    });

  });



}