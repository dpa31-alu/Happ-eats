import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happ_eats/models/message.dart';



class MessagesController {

  final FirebaseFirestore db;

  final MessageRepository repositoryMessages;

  MessagesController({required this.db, required this.repositoryMessages});

  /// Sends a message
  /// Requires the chatroom id, the id of the sender and recieverm and the text
  /// Returns null, or a string with an error
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

  /// Retrieves all the messages of a certain conversation
  /// Requires the dish id of the chatroom and the amount of messages
  /// Returns a stream with the information, or an error
  Stream<QuerySnapshot<Object?>?> retrieveConversationMessages(int amount, String id)  {
      return repositoryMessages.getMessagesForAmount(amount, id);
  }



}