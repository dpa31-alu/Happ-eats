import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String? uid;
  final String user;
  final String firstName;
  final String lastName;
  final String gender;
  final String medicalCondition;
  final double weight;
  final double height;
  final DateTime birthday;
  final String objectives;
  final String type;
  final String state;
  final Timestamp date;

//<editor-fold desc="Data Methods">
  const ApplicationModel({
     this.uid,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.medicalCondition,
    required this.weight,
    required this.height,
    required this.birthday,
    required this.objectives,
    required this.type,
    required this.state,
    required this.date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApplicationModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          user == other.user &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          gender == other.gender &&
          medicalCondition == other.medicalCondition &&
          weight == other.weight &&
          height == other.height &&
          birthday == other.birthday &&
          objectives == other.objectives &&
          type == other.type &&
          state == other.state &&
          date == other.date);

  @override
  int get hashCode =>
      uid.hashCode ^
      user.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      gender.hashCode ^
      medicalCondition.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      birthday.hashCode ^
      objectives.hashCode ^
      type.hashCode ^
      state.hashCode ^
      date.hashCode;

  @override
  String toString() {
    return 'Application{ uid: $uid, user: $user, firstName: $firstName, lastName: $lastName, gender: $gender, medicalCondition: $medicalCondition, weight: $weight, height: $height, birthday: $birthday, objectives: $objectives, type: $type, state: $state, date: $date,}';
  }

  ApplicationModel copyWith({
    String? uid,
    String? user,
    String? firstName,
    String? lastName,
    String? gender,
    String? medicalCondition,
    double? weight,
    double? height,
    DateTime? birthday,
    String? objectives,
    String? type,
    String? state,
    Timestamp? date,
  }) {
    return ApplicationModel(
      uid: uid ?? this.uid,
      user: user ?? this.user,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      birthday: birthday ?? this.birthday,
      objectives: objectives ?? this.objectives,
      type: type ?? this.type,
      state: state ?? this.state,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'user': user,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'medicalCondition': medicalCondition,
      'weight': weight,
      'height': height,
      'birthday': birthday,
      'objectives': objectives,
      'type': type,
      'state': state,
      'date': date,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      uid: map['uid'] as String?,
      user: map['user'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      gender: map['gender'] as String,
      medicalCondition: map['medicalCondition'] as String,
      weight: map['weight'] as double,
      height: map['height'] as double,
      birthday: map['birthday'].toDate() as DateTime,
      objectives: map['objectives'] as String,
      type: map['type'] as String,
      state: map['state'] as String,
      date: map['date'] as Timestamp,
    );
  }

  factory ApplicationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return ApplicationModel.fromMap(data).copyWith(uid: doc.id);
  }

//</editor-fold>

}

class ApplicationRepository {

  final FirebaseFirestore db;

  ApplicationRepository({required this.db});

  Future<Map<String, dynamic>> getApplicationForUserState(String uid) async {
    QuerySnapshot<Map<String, dynamic>> application = await db.collection('applications').where('user', isEqualTo: uid).limit(1).get();
    if (application.size != 0)
      {
        return ApplicationModel.fromDocument(application.docs[0]).toMap();
      }
    else {
      return {};
    }

  }

  Stream<QuerySnapshot> getAllApplicationsByType(String type, int amount) {
    return db.collection('applications').where('state', isEqualTo: 'Pending').where('type', isEqualTo: type).orderBy('date', descending: true).limit(amount).snapshots();
  }

  Future<WriteBatch> createApplication(WriteBatch batch, String newUser, String newFirstName,
      String newLastName, String newGender, String newMedicalCondition,
      double newWeight, double newHeight, DateTime newBirthday, String newObjectives, String newType) async {

    batch.set(db.collection('applications')
        .doc(), {
      'user': newUser,
      'firstName': newFirstName,
      'lastName': newLastName,
      'gender': newGender,
      'medicalCondition': newMedicalCondition,
      'weight': newWeight,
      'height': newHeight,
      'birthday': newBirthday,
      'objectives': newObjectives,
      'type': newType,
      'state': "Pending",
      'date': DateTime.timestamp(),
    });

    return batch;

  }

  Future<ApplicationModel> getApplicationForUser(String uid) async {
    var application = await db.collection('applications').where('user', isEqualTo: uid).limit(1).get();
    return ApplicationModel.fromDocument(application.docs[0]);
  }

  Future<WriteBatch> assignApplication(WriteBatch batch, String uid) async {
    var application = await db.collection('applications').where('user', isEqualTo: uid).get();
    batch.update(application.docs[0].reference, {
      'state':"Accepted",
    });
    return batch;
  }

  Future<WriteBatch> deleteApplication(WriteBatch batch, String uid) async {
    batch.delete(db.collection('applications').doc(uid));
    return batch;
  }

}


