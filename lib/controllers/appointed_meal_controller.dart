import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointed_meal.dart';
import '../models/dish.dart';


class AppointedMealsController {

  final FirebaseFirestore db;

  final repositoryAppointedMeal;

  final repositoryDish;

  AppointedMealsController({required this.db, required this.repositoryDish, required this.repositoryAppointedMeal});

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



  Stream<QuerySnapshot<Object?>> retrieveAllDishesForUser(String id, DateTime date)  {
    return repositoryAppointedMeal.getAllAppointmentsForToday(date, id);
  }


  Stream<QuerySnapshot> retrieveAllDishesForUserStream(DateTime dateStart, DateTime dateEnd, String id)  {
    return repositoryAppointedMeal.getAllAppointmentsStream(dateStart, dateEnd, id);
  }

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