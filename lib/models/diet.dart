
import 'package:cloud_firestore/cloud_firestore.dart';

class DietModel {
  final String? uid;
  final String patient;
  final String professional;
  final String firstName;
  final String lastName;
  final String gender;
  final String medicalCondition;
  final double weight;
  final double height;
  final DateTime birthday;
  final String objectives;
  final String type;
  final Timestamp date;
  final String? url;

//<editor-fold desc="Data Methods">
  const DietModel({
     this.uid,
    required this.patient,
    required this.professional,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.medicalCondition,
    required this.weight,
    required this.height,
    required this.birthday,
    required this.objectives,
    required this.type,
    required this.date,
    this.url,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DietModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          patient == other.patient &&
          professional == other.professional &&
          gender == other.gender &&
          medicalCondition == other.medicalCondition &&
          weight == other.weight &&
          height == other.height &&
          birthday == other.birthday &&
          objectives == other.objectives &&
          type == other.type &&
          date == other.date &&
          url == other.url);

  @override
  int get hashCode =>
      uid.hashCode ^
      patient.hashCode ^
      professional.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      gender.hashCode ^
      medicalCondition.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      birthday.hashCode ^
      objectives.hashCode ^
      type.hashCode ^
      date.hashCode ^
      url.hashCode;

  @override
  String toString() {
    return 'Diet{ uid: $uid, patient: $patient, professional: $professional, firstName: $firstName, lastName: $lastName, gender: $gender, medicalCondition: $medicalCondition, weight: $weight, height: $height, birthday: $birthday, objectives: $objectives, type: $type, date: $date, url: $url}';
  }

  DietModel copyWith({
    String? uid,
    String? patient,
    String? professional,
    String? firstName,
    String? lastName,
    String? gender,
    String? medicalCondition,
    double? weight,
    double? height,
    DateTime? birthday,
    String? objectives,
    String? type,
    Timestamp? date,
    String? url,
  }) {
    return DietModel(
      uid: uid ?? this.uid,
      patient: patient ?? this.patient,
      professional: professional ?? this.professional,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      birthday: birthday ?? this.birthday,
      objectives: objectives ?? this.objectives,
      type: type ?? this.type,
      date: date ?? this.date,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'patient': patient,
      'professional': professional,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'medicalCondition': medicalCondition,
      'weight': weight,
      'height': height,
      'birthday': birthday,
      'objectives': objectives,
      'type': type,
      'date': date,
      'url': url,
    };
  }

  factory DietModel.fromMap(Map<String, dynamic> map) {
    return DietModel(
      uid: map['uid'] as String?,
      patient: map['patient'] as String,
      professional: map['professional'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      gender: map['gender'] as String,
      medicalCondition: map['medicalCondition'] as String,
      weight: map['weight'] as double,
      height: map['height'] as double,
      birthday: map['birthday'].toDate() as DateTime,
      objectives: map['objectives'] as String,
      type: map['type'] as String,
      date: map['date'] as Timestamp,
      url: map['url'] as String?,
    );
  }

  factory DietModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return DietModel.fromMap(data).copyWith(uid: doc.id);
  }

  //</editor-fold>

}

class DietRepository {

  final FirebaseFirestore db;

  DietRepository({required this.db});

  /// Method for adding a diet's creation to a batch
  /// Requires the batch, patient, professional, first name, last name, gender, medical condition, weight, height, birthday, objectives and type
  /// Returns a write batch
  Future<WriteBatch> createDiet(WriteBatch batch, String newPatient, String newProfessional, String newFirstName, newLastName, String newGender, String newMedicalCondition,
      double newWeight, double newHeight, DateTime newBirthday, String newObjectives, String newType) async {

    batch.set(db.collection('diets')
        .doc(), {
      'patient': newPatient,
      'professional': newProfessional,
      'firstName': newFirstName,
      'lastName':newLastName,
      'gender': newGender,
      'medicalCondition': newMedicalCondition,
      'weight': newWeight,
      'height': newHeight,
      'birthday': newBirthday,
      'objectives': newObjectives,
      'type': newType,
      'date': DateTime.timestamp(),
    });

    return batch;

  }

  /// Method for adding a diet's first name update to a batch
  /// Requires the batch, diet uid and first name
  /// Returns a write batch
  Future<WriteBatch> updateDietFirstName(WriteBatch batch, String uid, String newFirstName) async {
    batch.update(db.collection('diets')
        .doc(uid), {
      'firstName': newFirstName,
    });
    return batch;
  }

  /// Method for adding a diet's last name update to a batch
  /// Requires the batch, diet uid and last name
  /// Returns a write batch
  Future<WriteBatch> updateDietLastName(WriteBatch batch, String uid, String newLastName,) async {
    batch.update(db.collection('diets')
        .doc(uid), {
      'lastName': newLastName,
    });
    return batch;
  }

  /// Method for adding a diet's gender update to a batch
  /// Requires the batch, diet uid and gender
  /// Returns a write batch
  Future<WriteBatch> updateDietGender(WriteBatch batch, String uid, String newGender) async {
    batch.update(db.collection('diets')
        .doc(uid), {
      'gender': newGender,
    });
    return batch;
  }

  /// Method for adding a diet's medical conditions update to a batch
  /// Requires the batch, diet uid and medical conditions
  /// Returns a write batch
  Future<WriteBatch> updateDietMedicalCondition(WriteBatch batch, String uid,
      String newMedicalCondition) async {
    batch.update(db.collection('diets')
        .doc(uid), {
      'medicalCondition': newMedicalCondition,
    });
    return batch;
  }

  /// Method for adding a diet's weight update to a batch
  /// Requires the batch, diet uid and weight
  /// Returns a write batch
  Future<WriteBatch> updateDietWeight(WriteBatch batch, String uid, String newWeight) async {
    batch.update(db.collection('diets')
        .doc(uid), {
      'weight': double.parse(newWeight),
    });
    return batch;
  }

  /// Method for adding a diet's height update to a batch
  /// Requires the batch, diet uid and height
  /// Returns a write batch
  Future<WriteBatch> updateDietHeight(WriteBatch batch, String uid, String newHeight) async {
    batch.update(db.collection('diets')
        .doc(uid), {
      'height': double.parse(newHeight),
    });
    return batch;
  }

  /// Method for adding a diet's birthday update to a batch
  /// Requires the batch, diet uid and birthday
  /// Returns a write batch
  Future<WriteBatch> updateDietBirthday(WriteBatch batch, String uid, String newBirthday) async {
    batch.update(db.collection('diets')
        .doc(uid), {
      'birthday': DateTime.parse(newBirthday),
    });
    return batch;
  }

  /// Method for adding a diet's deletion to a batch
  /// Requires the batch and diet uid
  /// Returns a write batch
  Future<WriteBatch> deleteDiet(WriteBatch batch, String uid) async {
    batch.delete(db.collection('diets').doc(uid));
    return batch;
  }

  /// Method for adding a diet's ref creation to a batch
  /// Requires the batch, diet uid and url
  /// Returns a write batch
  Future<WriteBatch> addRefApplication(WriteBatch batch, String uid, String url) async {

    batch.update(db.collection('diets').doc(uid), {
      'url' : url,
    });
    return batch;
  }

  /// Method for retrieving all diets for a certain professional
  /// Requires the type, amount and uid
  /// Returns a stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllDiets(String type, int amount, String id) {
    return db.collection('diets').where('professional', isEqualTo: id).where('type', isEqualTo: type).limit(amount).snapshots();
  }

  /// Method for retrieving a diet for a certain user
  /// Requires the uid of the patient
  /// Returns a map with the info or an empty map
  Future<Map<String, dynamic>> getDietForUser(String id) async {
    var diet = await db.collection('diets').where('patient', isEqualTo: id).limit(1).get();
    if (diet.size!=0)
    {
      return DietModel.fromDocument(diet.docs[0]).toMap();
    }
    else {
      Map<String, dynamic> map = {};
      return map;
    }

  }

  /// Method for retrieving all diets for a certain professional as a future
  /// Requires the uid of the professional
  /// Returns a future containing a query snapshot
  Future<QuerySnapshot<Map<String, dynamic>>> getAllDietsForProfessional(String id) async {
    QuerySnapshot<Map<String, dynamic>> diets = await db.collection('diets').where('professional', isEqualTo: id).get();
    return diets;
  }

}