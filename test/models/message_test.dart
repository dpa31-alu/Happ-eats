import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:happ_eats/models/message.dart';

import 'package:flutter_test/flutter_test.dart';



void main()  {


  group('Test Messages Repository', ()   {

    test('Messages for amount retrieves the correct amount of messages and in order', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      MessageRepository repository = MessageRepository(db: firestore);

      for(int i = 0; i < 21; i++) {
        firestore.collection('chatrooms').doc('$uid$uid').collection('messages').doc().set({'timestamp': Timestamp.fromDate(DateTime.now()),});
      }
      DateTime date = DateTime.now();
      firestore.collection('chatrooms').doc('$uid$uid').collection('messages').doc().set({'timestamp': Timestamp.fromDate(date),});

      repository.getMessagesForAmount(20,  '$uid$uid').listen(expectAsync1 ((snap) {
        expect(snap!.docChanges.length, 20);
        expect(snap.docChanges.first.doc.data(), {'timestamp': Timestamp.fromDate(date),} );
      }));

    });

    test('Send message adds message to batch correctly', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      MessageRepository repository = MessageRepository(db: firestore);

      //DateTime date = DateTime.now();


      WriteBatch batch = firestore.batch();
      batch = await repository.sendMessage(batch, '$uid$uid', uid, uid, 'text');
      batch.commit();
      QuerySnapshot<Map<String, dynamic>> a = await firestore.collection('chatrooms').doc('$uid$uid').collection('messages').get();
      expect(a.docs[0].data()['text'], 'text');

    });

    test('Delete message adds tasks to batch correctly', () async {
      MockFirebaseAuth auth = MockFirebaseAuth();
      final firestore = FakeFirebaseFirestore(
          authObject: auth.authForFakeFirestore);
      await auth.signInWithCustomToken('some token');
      final uid = auth.currentUser!.uid;
      MessageRepository repository = MessageRepository(db: firestore);

      for(int i = 0; i < 21; i++) {
        firestore.collection('chatrooms').doc('$uid$uid').collection('messages').doc().set({'timestamp': Timestamp.fromDate(DateTime.now()),});
      }

      QuerySnapshot<Map<String, dynamic>> test = await firestore.collection('chatrooms').doc('$uid$uid').collection('messages').get();
      expect(test.docs.length, 21);

      WriteBatch batch = firestore.batch();
      batch = await repository.deleteAllUserMessages(batch, '$uid$uid');
      batch.commit();

      QuerySnapshot<Map<String, dynamic>> a = await firestore.collection('chatrooms').doc('$uid$uid').collection('messages').get();
      expect(a.docs.length, 0);

    });

  });
}