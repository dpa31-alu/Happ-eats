import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/user_controller.dart';
import 'package:happ_eats/models/appointed_meal.dart';
import 'package:happ_eats/models/dish.dart';
import 'package:intl/intl.dart';

import '../controllers/appointed_meal_controller.dart';
import '../models/application.dart';
import '../models/diet.dart';
import '../models/message.dart';
import '../models/patient.dart';
import '../models/professional.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class Tracker extends StatefulWidget {
  final String gender;
   const Tracker({super.key, required this.gender});

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {


   final AppointedMealsController _controllerMeals = AppointedMealsController(db: FirebaseFirestore.instance, repositoryDish: DishRepository(db: FirebaseFirestore.instance), repositoryAppointedMeal: AppointedMealRepository(db: FirebaseFirestore.instance));

   final UsersController _controllerUsers = UsersController(
     db: FirebaseFirestore.instance,
     auth: AuthService(auth: FirebaseAuth.instance,),
     repositoryUser: UserRepository(db: FirebaseFirestore.instance),
     repositoryProfessional: ProfessionalRepository(db: FirebaseFirestore.instance),
     repositoryMessages: MessageRepository(db: FirebaseFirestore.instance),
     repositoryPatient: PatientRepository(db: FirebaseFirestore.instance),
     repositoryDish: DishRepository(db: FirebaseFirestore.instance),
     repositoryAppointedMeal: AppointedMealRepository(db: FirebaseFirestore.instance),
     repositoryApplication: ApplicationRepository(db: FirebaseFirestore.instance),
     repositoryDiets: DietRepository(db: FirebaseFirestore.instance),);

   final _dateController = TextEditingController();
   late final String? _uid = _controllerUsers.getCurrentUserUid();

   DateTime _focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);


   @override
  void initState() {

    super.initState();

  }



  final Map<String, dynamic> _quantitiesMale = {'Calorías (kcal)': 3000.0,
    'Proteínas (g)': 54.0,
    'Lípidos totales (g)' : 100.0,
    'AG saturados (g)' : 23.0,
    'AG monoinsaturados (g)' : 67.0,
    'AG poliinsaturados (g)' : 17.0,
    'Omega-3 (g)' : 3.3,
    'C18:2 Linoleico (omega-6) (g)' : 10.0,
    'Colesterol (mg/1000 kcal)' : 300.0,
    'Hidratos de carbono (g)' : 375.0,
    'Fibra (g)' : 35.0,
    'Agua (g)' : 2500.0,

    'Calcio (mg)' : 1000.00,
    'Hierro (mg)' : 10.0,
    'Yodo (µg)' : 140.0,
    'Magnesio (mg)' : 350.0,
    'Zinc (mg)' : 15.0,
    'Sodio (mg)' : 2000.0,
    'Potasio (mg)' : 3500.0,
    'Fósforo (mg)' : 700.0,
    'Selenio (μg)' : 70.0,

    'Tiamina (mg)' : 1.2,
    'Riboflavina (mg)' : 1.8,
    'Equivalentes niacina (mg)' : 20.0,
    'Vitamina B6 (mg)' : 1.8,
    'Folatos (μg)' : 400.0,
    'Vitamina B12 (μg)' : 2.0,
    'Vitamina C (mg)' : 60.0,
    'Vitamina A: Eq. Retinol (μg)' : 1000.0,
    'Vitamina D (μg)' : 15.0,
    'Vitamina E (mg)' : 12.0};

  final Map<String, dynamic> _quantitiesFemale = {'Calorías (kcal)': 2300.0,
    'Proteínas (g)' : 41.0,
    'Lípidos totales (g)' : 77.0,
    'AG saturados (g)': 18.0,
    'AG monoinsaturados (g)': 51.0,
    'AG poliinsaturados (g)': 13.0,
    'Omega-3 (g)': 2.6,
    'C18:2 Linoleico (omega-6) (g)': 8.0,
    'Colesterol (mg/1000 kcal)' : 230.0,
    'Hidratos de carbono (g)' : 288.0,
    'Fibra (g)': 25.0,
    'Agua (g)': 2000.0,

    'Calcio (mg)' : 1000.0,
    'Hierro (mg)' : 18.0,
    'Yodo (µg)' : 110.0,
    'Magnesio (mg)' : 330.0,
    'Zinc (mg)' : 15.0,
    'Sodio (mg)' : 2000.0,
    'Potasio (mg)' : 3500.0,
    'Fósforo (mg)' : 700.0,
    'Selenio (μg)' : 55.0,

    'Tiamina (mg)' : 0.9,
    'Riboflavina (mg)' : 1.4,
    'Equivalentes niacina (mg)' : 15.0,
    'Vitamina B6 (mg)' : 1.6,
    'Folatos (μg)' : 400.0,
    'Vitamina B12 (μg)' : 2.0,
    'Vitamina C (mg)' : 60.0,
    'Vitamina A: Eq. Retinol (μg)' : 800.0,
    'Vitamina D (μg)' : 15.0,
    'Vitamina E (mg)' : 12.0};

  Map<String, dynamic> _dishValues = {};


  double _progressCalculator (double valueRetrieved, double valueMax) {
    return (valueRetrieved * 100 / valueMax)/100;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Text("Happ-eats"),
        ),
        body: SafeArea(
          child: Column(children: [
            Padding(
                padding:const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0, bottom: 10.0),
                child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: "Introduce el día a comprobar"
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          locale: const Locale("es", "ES"),
                          initialDate: DateTime.now(),
                          firstDate:DateTime(1940),
                          lastDate: DateTime(2101)
                      );

                      if (pickedDate != null) {

                        DateTime dayUser = DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day);

                        if(_focusedDay != dayUser)
                        {
                          setState(() {
                            _focusedDay = dayUser;
                          });
                        }
                        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    }
                )
            ),
            StreamBuilder(
                stream:  _controllerMeals.retrieveAllDishesForUser(_uid!, _focusedDay),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                  {
                    return  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.3,
                        ),
                        const Center(child: CircularProgressIndicator(),)
                      ],
                    );
                  }
                  else if (snapshot.hasError) {
                    return  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.3,
                        ),
                        const Center(child: Text("No se han podido recuperar los datos"),)
                      ],
                    );
                  }
                  else if (snapshot.data != null) {

                    _dishValues = {};
                    for (DocumentSnapshot doc in snapshot.data!.docs) {

                      for(int i = 0; i < doc['values'].length -1; i++){

                        String key = _quantitiesMale.keys.elementAt(i);

                        if(_dishValues[key]==null) {
                          _dishValues[key] =    doc['values'][key];
                        }
                        else {
                          _dishValues[key] =  _dishValues[key] + doc['values'][key];
                        }

                      }

                    }

                    if(_dishValues.isNotEmpty) {
                      return
                        Expanded(
                            child:ListView.builder(
                              padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                              /*gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),*/
                              itemCount: 31,
                              itemBuilder: (BuildContext context, int index) {

                                double numberMax;
                                double valueCircle;
                                double numberRetrieved = _dishValues[_dishValues.keys.elementAt(index)];

                                if (widget.gender == 'M') {
                                  numberMax = _quantitiesMale[_dishValues.keys.elementAt(index)];
                                  valueCircle = _progressCalculator(numberRetrieved, numberMax);
                                } else {
                                  numberMax = _quantitiesFemale[_dishValues.keys.elementAt(index)];
                                  valueCircle =  _progressCalculator(numberRetrieved, numberMax);
                                }
                                return Card(
                                  child: ExpansionTile(
                                      leading:
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          value: (widget.gender=='M') ?valueCircle
                                              :valueCircle,
                                          semanticsLabel: 'Circular progress indicator',
                                          color: (numberMax<numberRetrieved) ? Colors.redAccent : Colors.orangeAccent,
                                        ),
                                      ),
                                      title:
                                      Text(
                                        _dishValues.keys.elementAt(index),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 20
                                        ),),

                                      children: [
                                        ListTile(
                                          title: const Text('Camtidad en la alimentación suministrada'),
                                          trailing: Text(numberRetrieved.toStringAsFixed(3)),
                                        ),
                                        ListTile(
                                          title: const Text('Camtidad en la alimentación recomendada'),
                                          trailing: Text(numberMax.toString()),
                                        ),
                                      ]
                                  ),
                                );
                              },
                            )
                        );

                    } else {
                      return  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height * 0.3,
                          ),
                          const Center(

                            child: Text("No se han recuperado datos"),
                          )
                        ],
                      );
                    }
                  } else {
                    return  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.3,
                        ),
                        const Center(
                          child: Text("No se han recuperado datos"),
                        )
                      ],
                    );
                  }
                }
            ),
          ],),
        )
    );
  }
}