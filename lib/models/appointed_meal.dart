
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointedMealModel {
  final String uid;
  final String patient;
  final String professional;
  final bool followedCorrectly;
  final bool alternativeRequired;
  final String note;
  final String diet;
  final DateTime appointedDate;
  final String dish;
  final String dishName;
  final int mealOrder;

  //<editor-fold desc="Data Methods">
  const AppointedMealModel({
    required this.uid,
    required this.patient,
    required this.professional,
    required this.followedCorrectly,
    required this.alternativeRequired,
    required this.note,
    required this.diet,
    required this.appointedDate,
    required this.dish,
    required this.dishName,
    required this.mealOrder,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AppointedMealModel &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              patient == other.patient &&
              professional == other.professional &&
              followedCorrectly == other.followedCorrectly &&
              alternativeRequired == other.alternativeRequired &&
              note == other.note &&
              diet == other.diet &&
              appointedDate == other.appointedDate &&
              dish == other.dish &&
              dishName == other.dishName &&
              mealOrder == other.mealOrder);

  @override
  int get hashCode =>
      uid.hashCode ^
      patient.hashCode ^
      professional.hashCode ^
      followedCorrectly.hashCode ^
      alternativeRequired.hashCode ^
      note.hashCode ^
      diet.hashCode ^
      appointedDate.hashCode ^
      dish.hashCode ^
      dishName.hashCode ^
      mealOrder.hashCode;

  @override
  String toString() {
    return 'AppointedMealModel{' +
        ' uid: $uid,' +
        ' patient: $patient,' +
        ' professional: $professional,' +
        ' followedCorrectly: $followedCorrectly,' +
        ' alternativeRequired: $alternativeRequired,' +
        ' note: $note,' +
        ' diet: $diet,' +
        ' appointedDate: $appointedDate,' +
        ' dish: $dish,' +
        ' dishName: $dishName,' +
        ' mealOrder: $mealOrder,' +
        '}';
  }

  AppointedMealModel copyWith({
    String? uid,
    String? patient,
    String? professional,
    bool? followedCorrectly,
    bool? alternativeRequired,
    String? note,
    String? diet,
    DateTime? appointedDate,
    String? dish,
    String? dishName,
    int? mealOrder,
  }) {
    return AppointedMealModel(
      uid: uid ?? this.uid,
      patient: patient ?? this.patient,
      professional: professional ?? this.professional,
      followedCorrectly: followedCorrectly ?? this.followedCorrectly,
      alternativeRequired: alternativeRequired ?? this.alternativeRequired,
      note: note ?? this.note,
      diet: diet ?? this.diet,
      appointedDate: appointedDate ?? this.appointedDate,
      dish: dish ?? this.dish,
      dishName: dishName ?? this.dishName,
      mealOrder: mealOrder ?? this.mealOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'patient': patient,
      'professional': professional,
      'followedCorrectly': followedCorrectly,
      'alternativeRequired': alternativeRequired,
      'note': note,
      'diet': diet,
      'appointedDate': appointedDate,
      'dish': dish,
      'dishName': dishName,
      'mealOrder': mealOrder,
    };
  }

  factory AppointedMealModel.fromMap(Map<String, dynamic> map) {
    return AppointedMealModel(
      uid: map['uid'] as String,
      patient: map['patient'] as String,
      professional: map['professional'] as String,
      followedCorrectly: map['followedCorrectly'] as bool,
      alternativeRequired: map['alternativeRequired'] as bool,
      note: map['note'] as String,
      diet: map['diet'] as String,
      appointedDate: map['appointedDate'] as DateTime,
      dish: map['dish'] as String,
      dishName: map['dishName'] as String,
      mealOrder: map['mealOrder'] as int,
    );
  }

//</editor-fold>
}

class AppointedMealRepository {

  final FirebaseFirestore db;

  AppointedMealRepository({required this.db});

  /// Method for adding an appointed meal's creation to the batch
  /// Requires the batch, id, diet id, professional id, patient id, date of the appointment, dish id, dish name, meal order and nutritional values map
  /// Returns a write batch
  Future<WriteBatch> createAppointedMeal(WriteBatch batch, String id, String diet, String professional, String patient, DateTime appointedDate,
      String dish, String dishName, int mealOrder, Map<String, dynamic> values) async {

    batch.set(db.collection('appointedMeals')
        .doc(id), {
      'alternativeRequired': false,
      'diet': diet,
      'professional': professional,
      'patient': patient,
      'appointedDate': appointedDate,
      'dish': dish,
      'dishName': dishName,
      'values': values,
      'mealOrder': mealOrder
    },
    );
    return batch;
  }

  /// Method for adding an appointed meal's issues to the batch
  /// Requires the batch, text and user id
  /// Returns a write batch
  Future<WriteBatch> signalIssuesAppointedMeal(WriteBatch batch, String id, String note) async {

    batch.update(db.collection('appointedMeals')
        .doc(id), {
      'alternativeRequired': true,
      'note': note,
    },
    );
    return batch;
  }

  /// Method for adding an appointed meal's confirmation to the batch
  /// Requires the batch and user id
  /// Returns a write batch
  Future<WriteBatch> consumedCorrectlyAppointedMeal(WriteBatch batch, String id) async {

    batch.update(db.collection('appointedMeals')
        .doc(id), {
      'followedCorrectly': true,
    },
    );
    return batch;
  }

  /// Method for retrieving all appointed meals for a certain day and user
  /// Requires the id of the user and the date for which the appointments were made
  /// Returns a stream containing the data or an error
  Stream<QuerySnapshot> getAllAppointmentsForToday(DateTime date, String id) {
    return db.collection('appointedMeals').where('patient', isEqualTo: id)
        .where('appointedDate', isEqualTo: date).where('followedCorrectly', isEqualTo: true).snapshots();
  }

  /// Method for retrieving all appointed meals within a time frame
  /// Requires the id of the patient, professional and the start and end dates for which the appointments were made
  /// Returns a stream containing the data or an error
  Stream<QuerySnapshot> getAllAppointmentsStream(DateTime dateStart, DateTime dateEnd, String idPatient, idProfessional) {
    return db.collection('appointedMeals').where('patient', isEqualTo: idPatient).where('professional', isEqualTo: idProfessional)
        .where('appointedDate', isGreaterThanOrEqualTo: dateStart).where('appointedDate', isLessThanOrEqualTo: dateEnd).snapshots();
  }

  /// Method for adding all appointed meals' deletion to the batch
  /// Requires the batch and user id, and if the user is a patient or not
  /// Returns a write batch
  Future<WriteBatch> deleteAllUserMeals(WriteBatch batch, String id, bool isPatient) async {

    if(isPatient) {
      QuerySnapshot<Map<String, dynamic>> docs = await db.collection('appointedMeals').where('patient', isEqualTo: id).get();
      for(DocumentSnapshot docu in docs.docs) {
        batch.delete(db.collection('appointedMeals')
            .doc(docu.id));
      }
      }
    else {
      QuerySnapshot<Map<String, dynamic>> docs = await db.collection('appointedMeals').where('professional', isEqualTo: id).get();
      for(DocumentSnapshot docu in docs.docs) {
        batch.delete(db.collection('appointedMeals')
            .doc(docu.id));
      }
    }
    return batch;
  }
}