
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String? user;
  final String gender;
  final String medicalCondition;
  final double weight;
  final double startingWeight;
  final double height;
  final DateTime birthday;


//<editor-fold desc="Data Methods">
  const PatientModel({
     this.user,
    required this.gender,
    required this.medicalCondition,
    required this.weight,
    required this.startingWeight,
    required this.height,
    required this.birthday,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientModel &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          gender == other.gender &&
          medicalCondition == other.medicalCondition &&
          weight == other.weight &&
          startingWeight == other.startingWeight &&
          height == other.height &&
          birthday == other.birthday);

  @override
  int get hashCode =>
      user.hashCode ^
      gender.hashCode ^
      medicalCondition.hashCode ^
      weight.hashCode ^
      startingWeight.hashCode ^
      height.hashCode ^
      birthday.hashCode;

  @override
  String toString() {
    return 'Patient{ user: $user, gender: $gender, medicalCondition: $medicalCondition, weight: $weight, startingWeight: $startingWeight, height: $height, birthday: $birthday,}';
  }

  PatientModel copyWith({
    String? user,
    String? gender,
    String? medicalCondition,
    double? weight,
    double? startingWeight,
    double? height,
    DateTime? birthday,
  }) {
    return PatientModel(
      user: user ?? this.user,
      gender: gender ?? this.gender,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      weight: weight ?? this.weight,
      startingWeight: startingWeight ?? this.startingWeight,
      height: height ?? this.height,
      birthday: birthday ?? this.birthday,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'gender': gender,
      'medicalCondition': medicalCondition,
      'weight': weight,
      'startingWeight': startingWeight,
      'height': height,
      'birthday': birthday,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      user: map['user'] as String?,
      gender: map['gender'] as String,
      medicalCondition: map['medicalCondition'] as String,
      weight: double.parse(map['weight'].toString()),
      startingWeight: double.parse(map['startingWeight'].toString()),
      height: double.parse(map['height'].toString()),
      birthday: map['birthday'].toDate() as DateTime,
    );
  }

  factory PatientModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return PatientModel.fromMap(data).copyWith(user: doc.id);
  }

//</editor-fold>


}

class PatientRepository {

  final FirebaseFirestore db;

  PatientRepository({required this.db});

  /// Method for adding a patient's creation to a batch
  /// Requires the batch, id, gender, medical condition, height, weight and birthday
  /// Returns a write batch
  Future<WriteBatch> createPatient(WriteBatch batch, String uid, String newGender,
      String newMedicalCondition, String newWeight, String newHeight, String newBirthday) async {

    batch.set(db.collection('patients')
        .doc(uid), {
      'gender': newGender,
      'medicalCondition': newMedicalCondition,
      'weight': double.parse(newWeight),
      'startingWeight': double.parse(newWeight),
      'height': double.parse(newHeight),
      'birthday': DateTime.parse(newBirthday),
    });

    return batch;

  }

  /// Method for adding a patient's deletion to a batch
  /// Requires the batch and id
  /// Returns a write batch
 Future<WriteBatch> deletePatient(WriteBatch batch, String uid) async {

    batch.delete(db.collection('patients').doc(uid));
    return batch;

  }

  /// Method for adding a patient's gender update to a batch
  /// Requires the batch, id and gender
  /// Returns a write batch
 Future<WriteBatch> updatePatientGender(WriteBatch batch, String uid, String newGender) async {
    batch.update(db.collection('patients')
        .doc(uid), {
      'gender': newGender,
    });
    return batch;
  }

  /// Method for adding a patient's medical condition update to a batch
  /// Requires the batch, id and medical condition
  /// Returns a write batch
  Future<WriteBatch> updatePatientMedicalCondition(WriteBatch batch, String uid,
      String newMedicalCondition) async {
    batch.update(db.collection('patients')
        .doc(uid), {
      'medicalCondition': newMedicalCondition,
    });
    return batch;
  }

  /// Method for adding a patient's weight update to a batch
  /// Requires the batch, id and weight
  /// Returns a write batch
  Future<WriteBatch> updatePatientWeight(WriteBatch batch, String uid, String newWeight) async {
    batch.update(db.collection('patients')
        .doc(uid), {
      'weight': double.parse(newWeight),
    });
    return batch;
  }

  /// Method for adding a patient's height update to a batch
  /// Requires the batch, id and height
  /// Returns a write batch
  Future<WriteBatch> updatePatientHeight(WriteBatch batch, String uid, String newHeight) async {
    batch.update(db.collection('patients')
        .doc(uid), {
      'height': double.parse(newHeight),
    });
    return batch;
  }

  /// Method for adding a patient's birthday update to a batch
  /// Requires the batch, id and birthday
  /// Returns a write batch
  Future<WriteBatch> updatePatientBirthday(WriteBatch batch, String uid, String newBirthday) async {
    batch.update(db.collection('patients')
        .doc(uid), {
      'birthday': DateTime.parse(newBirthday),
    });
    return batch;
  }

  /// Method for retrieving whether a id belongs to a patient or not
  /// Requires the id
  /// Returns a future containing a bool
  Future<bool> isPatient(String uid) async {
    DocumentSnapshot doc = await db.collection('patients').doc(uid).get();
    if (doc.data()!=null)
    {
      return true;
    }
    else {
      return false;
    }
  }

  /// Method for retrieving a patient's data'
  /// Requires the id
  /// Returns a future containing a PatientModel object
  Future<PatientModel> getPatient(String uid) async {
    var user = await db.collection('patients').doc(uid).get();
    return PatientModel.fromDocument(user);
  }

}