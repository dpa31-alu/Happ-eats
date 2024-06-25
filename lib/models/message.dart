import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String toID;
  final String fromID;
  final String text;
  final Timestamp timestamp;


//<editor-fold desc="Data Methods">
  const MessageModel({
    required this.toID,
    required this.fromID,
    required this.text,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageModel &&
          runtimeType == other.runtimeType &&
          toID == other.toID &&
          fromID == other.fromID &&
          text == other.text &&
          timestamp == other.timestamp);

  @override
  int get hashCode =>
      toID.hashCode ^ fromID.hashCode ^ text.hashCode ^ timestamp.hashCode;

  @override
  String toString() {
    return 'MessageModel{' +
        ' toID: $toID,' +
        ' fromID: $fromID,' +
        ' text: $text,' +
        ' timestamp: $timestamp,' +
        '}';
  }

  MessageModel copyWith({
    String? toID,
    String? fromID,
    String? text,
    Timestamp? timestamp,
  }) {
    return MessageModel(
      toID: toID ?? this.toID,
      fromID: fromID ?? this.fromID,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'toID': toID,
      'fromID': fromID,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      toID: map['toID'] as String,
      fromID: map['fromID'] as String,
      text: map['text'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

//</editor-fold>



}

class MessageRepository {

  final FirebaseFirestore db;

  MessageRepository({required this.db});

  Stream<QuerySnapshot?> getMessagesForAmount(int amount, String uid) {
    return db.collection('chatrooms').doc(uid).collection('messages').limit(amount).orderBy('timestamp', descending: true).snapshots();
  }

  Future<WriteBatch> sendMessage(WriteBatch batch, String uid, String toID, String fromID, String text) async {

    batch.set(db.collection('chatrooms').doc(uid).collection('messages')
        .doc(), {
      'toID':toID,
      'fromID':fromID,
      'text':text,
      'timestamp':DateTime.timestamp()
    });
    return batch;

  }

  Future<WriteBatch> deleteAllUserMessages(WriteBatch batch, String uid) async {

    QuerySnapshot<Map<String, dynamic>> docs = await db.collection('chatrooms').doc(uid).collection('messages').get();
    for(DocumentSnapshot docu in docs.docs) {
      batch.delete(db.collection('chatrooms').doc(uid).collection('messages').doc(docu.id));
    }
    batch.delete(db.collection('chatrooms').doc(uid));
    return batch;


  }
}