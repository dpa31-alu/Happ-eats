import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happ_eats/models/message.dart';



class MessagesController {

  final FirebaseFirestore db;

  final MessageRepository repositoryMessages;

  MessagesController({required this.db, required this.repositoryMessages});

  Future<String?> sendMessage(String chatroomId , String toId, String fromId, String text) async {
    try {
      WriteBatch batch = db.batch();
      batch = await repositoryMessages.sendMessage(batch, chatroomId, toId, fromId, text);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  Stream<QuerySnapshot<Object?>?> retrieveConversationMessages(int amount, String id)  {
      return repositoryMessages.getMessagesForAmount(amount, id);
  }



}