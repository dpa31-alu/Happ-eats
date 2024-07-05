import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happ_eats/models/appointed_meal.dart';
import 'package:happ_eats/models/dish.dart';



class AppointedMealsController {

  final FirebaseFirestore db;

  final AppointedMealRepository repositoryAppointedMeal;

  final DishRepository repositoryDish;

  AppointedMealsController({required this.db, required this.repositoryDish, required this.repositoryAppointedMeal});

  /// Method for creating an appointed meal
  /// Requires the dish name, its id, the diet it belongs to, the professional and patient attached to that diet, the time for the appointment, and the meal it corresponds to
  /// Returns null, or a string containing an error
  Future<String?> createAppointment(String dishName, String dish, String diet, String professional, String patient, DateTime appointedDate, int order) async {
    try {

      WriteBatch batch = db.batch();
      String id = "${appointedDate.day}-${appointedDate.month}-${appointedDate.year}_${diet}_${order.toString()}";
      DocumentSnapshot<Map<String, dynamic>> doc = await repositoryDish.getDish(dish);
      Map<String, dynamic> map  = doc['nutritionalInfo'];
      batch = await repositoryAppointedMeal.createAppointedMeal(batch, id, diet, professional, patient, appointedDate, dish, dishName, order, map);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }


  /// Method for retrieving all appointed meals for a certain day and user
  /// Requires the id of the user and the date for which the appointments were made
  /// Returns a stream containing the data or an error
  Stream<QuerySnapshot<Object?>> retrieveAllDishesForUser(String id, DateTime date)  {
    return repositoryAppointedMeal.getAllAppointmentsForToday(date, id);
  }

  /// Method for retrieving all appointed meals within a time frame
  /// Requires the id of the patient, professional and the start and end dates for which the appointments were made
  /// Returns a stream containing the data or an error
  Stream<QuerySnapshot> retrieveAllDishesForUserStream(DateTime dateStart, DateTime dateEnd, String idPatient, String idProfessional)  {
    return repositoryAppointedMeal.getAllAppointmentsStream(dateStart, dateEnd, idPatient, idProfessional);
  }

  /// Method for confirming an appointed meal
  /// Requires the id of the appointedMeal to modify
  /// Returns null, or a string containing an error
  Future<String?> confirmConsumption(String id)  async {
    try {
      WriteBatch batch = db.batch();
      batch = await repositoryAppointedMeal.consumedCorrectlyAppointedMeal(batch, id);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }

  /// Method for notifying errors on an appointed meal
  /// Requires the id of the appointedMeal to modify, and a string with the warning
  /// Returns null, or a string containing an error
  Future<String?> writeNote(String id, String note)  async {
    try {
      WriteBatch batch = db.batch();
      batch = await repositoryAppointedMeal.signalIssuesAppointedMeal(batch, id, note);
      await batch.commit();
    }
    on FirebaseException catch (ex) {
      return ex.message;
    }
    return null;
  }



}