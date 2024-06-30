
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

  Future<WriteBatch> signalIssuesAppointedMeal(WriteBatch batch, String id, String note) async {

    batch.update(db.collection('appointedMeals')
        .doc(id), {
      'alternativeRequired': true,
      'note': note,
    },
    );
    return batch;
  }

  Future<WriteBatch> consumedCorrectlyAppointedMeal(WriteBatch batch, String id) async {

    batch.update(db.collection('appointedMeals')
        .doc(id), {
      'followedCorrectly': true,
    },
    );
    return batch;
  }

  Stream<QuerySnapshot> getAllAppointmentsForToday(DateTime date, String id) {
    return db.collection('appointedMeals').where('patient', isEqualTo: id)
        .where('appointedDate', isEqualTo: date).where('followedCorrectly', isEqualTo: true).snapshots();
  }

  Stream<QuerySnapshot> getAllAppointmentsStream(DateTime dateStart, DateTime dateEnd, String idPatient, idProfessional) {
    return db.collection('appointedMeals').where('patient', isEqualTo: idPatient).where('professional', isEqualTo: idProfessional)
        .where('appointedDate', isGreaterThanOrEqualTo: dateStart).where('appointedDate', isLessThanOrEqualTo: dateEnd).snapshots();
  }

  Future<WriteBatch> deleteAllUserMeals(WriteBatch batch, String id) async {

    QuerySnapshot<Map<String, dynamic>> docs = await db.collection('appointedMeals').where('patient', isEqualTo: id).get();
    for(DocumentSnapshot docu in docs.docs) {
      batch.delete(db.collection('appointedMeals')
          .doc(docu.id));
    }
    return batch;
  }
}