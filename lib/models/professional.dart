import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionalModel {
  final String? user;
  final String collegeNumber;

//<editor-fold desc="Data Methods">
  const ProfessionalModel({
     this.user,
    required this.collegeNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfessionalModel &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          collegeNumber == other.collegeNumber);

  @override
  int get hashCode => user.hashCode ^ collegeNumber.hashCode;

  @override
  String toString() {
    return 'Professional{ user: $user, collegeNumber: $collegeNumber,}';
  }

  ProfessionalModel copyWith({
    String? user,
    String? collegeNumber,
  }) {
    return ProfessionalModel(
      user: user ?? this.user,
      collegeNumber: collegeNumber ?? this.collegeNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'collegeNumber': collegeNumber,
    };
  }

  factory ProfessionalModel.fromMap(Map<String, dynamic> map) {
    return ProfessionalModel(
      user: map['user'] as String?,
      collegeNumber: map['collegeNumber'] as String,
    );
  }

  factory ProfessionalModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return ProfessionalModel.fromMap(data).copyWith(user: doc.id);
  }

//</editor-fold>
}

class ProfessionalRepository {

  final FirebaseFirestore db;

  ProfessionalRepository({required this.db});

   Future<WriteBatch> createProfessional(WriteBatch batch, String uid, String newCollegeNumber) async {

    batch.set(db.collection('professionals')
        .doc(uid), {
      'collegeNumber': newCollegeNumber,
    });

    return batch;
  }

   Future<WriteBatch> deleteProfessional(WriteBatch batch, String uid) async {
    batch.delete(db.collection('professionals').doc(uid));
    return batch;
  }

  Future<ProfessionalModel> getProfessional(String uid) async {
    var user = await db.collection('professionals').doc(uid).get();
    return ProfessionalModel.fromDocument(user);
  }

}