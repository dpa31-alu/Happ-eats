import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/appointed_meal_controller.dart';
import 'package:happ_eats/controllers/dish_controller.dart';
import 'package:happ_eats/models/user.dart';
import 'package:happ_eats/pages/recipe.dart';
import 'package:happ_eats/services/file_service.dart';
import 'package:happ_eats/utils/loading_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/appointed_meal.dart';
import '../models/dish.dart';
import '../services/auth_service.dart';


class CalendarPatient extends StatefulWidget {

  final String patientID;
  final String professionalID;

  const CalendarPatient({super.key, required this.patientID, required this.professionalID});

  @override
  CalendarPatientState createState() {
    return CalendarPatientState();
  }
}

class CalendarPatientState extends State<CalendarPatient> {


  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final _problemController = TextEditingController();

  final AppointedMealsController _controllerMeals = AppointedMealsController(db: FirebaseFirestore.instance, repositoryDish: DishRepository(db: FirebaseFirestore.instance), repositoryAppointedMeal: AppointedMealRepository(db: FirebaseFirestore.instance));


  final DishesController _controllerDishes = DishesController(db: FirebaseFirestore.instance,
      auth: AuthService(auth: FirebaseAuth.instance,),
      file: FileService(storage: FirebaseStorage.instance, auth: AuthService(auth: FirebaseAuth.instance,)),
      repositoryUser: UserRepository(db: FirebaseFirestore.instance),
      repositoryDish: DishRepository(db: FirebaseFirestore.instance));

  late Map<DateTime, List<Map<String, dynamic>>> _events;

  List<Map<String, dynamic>> _selectedEvents = [];



  @override
  void initState() {

    //_stateEvents = _controllerMeals.retrieveAllDishesForUserStream(_findNearestMonday(_focusedDay), _findNearestSunday(_focusedDay), widget.dietID);

    //_eventsLoader();

    _events = LinkedHashMap(
        equals: isSameDay,
        hashCode: generateHash
    );

    super.initState();
  }

  List<Map<String, dynamic>> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  DateTime _findNearestMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime _findNearestSunday(DateTime date) {
    return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
  }

  int generateHash(DateTime date) {
    return date.day * 1000000 + date.month * 10000 + date.year;
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        key: _key,
        appBar: AppBar(
          //leading: Icon(Icons.account_circle_rounded),
            title: const Text("Happ-eats"),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0,),
                    child:  StreamBuilder (
                        stream: _controllerMeals.retrieveAllDishesForUserStream(_findNearestMonday(_focusedDay), _findNearestSunday(_focusedDay), widget.patientID, widget.professionalID),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return  const Center(child: Text("No se han podido recuperar el calendario"),);
                          }
                          else if (snapshot.data != null)
                          {
                            _events = LinkedHashMap(
                                equals: isSameDay,
                                hashCode: generateHash
                            );

                            for (DocumentSnapshot<Map<String, dynamic>> a in snapshot.data!.docs)
                            {

                              Map<String, dynamic>? p = a.data();
                              DateTime date = a['appointedDate'].toDate();
                              DateTime day = DateTime.utc(date.year, date.month, date.day);
                              if (_events[day] == null)
                              {
                                _events[day] = [];
                              }
                              _events[day]!.add(p!);

                            }
                            _selectedEvents = _getEventsForTheDay(_focusedDay);
                            _selectedEvents.sort((a, b) => (a['mealOrder']).compareTo(b['mealOrder']));

                          }

                          return Column(
                            children: [
                              TableCalendar(
                                eventLoader: _getEventsForTheDay,
                                locale: Localizations.localeOf(context).languageCode,
                                firstDay: DateTime.utc(2024, 1, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                    _selectedEvents = _getEventsForTheDay(_focusedDay);
                                  });
                                },
                                calendarFormat: _calendarFormat,
                                availableCalendarFormats: const {
                                  CalendarFormat.week : 'Semana'
                                },
                                onPageChanged: (focusedDay) {
                                  setState(() {
                                    _focusedDay = focusedDay;
                                  });
                                },
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                calendarStyle: CalendarStyle(
                                  isTodayHighlighted: true,
                                  todayDecoration: BoxDecoration(
                                    color: Colors.orangeAccent.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.lightBlueAccent.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  outsideDaysVisible: false,
                                ),
                              ),

                              const Divider(),
                              if (_selectedEvents.isNotEmpty) ListView.builder(
                                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                  shrinkWrap: true,
                                  itemCount:  _selectedEvents.length,
                                  itemBuilder: (context, index) {
                                    return Card.outlined(
                                        child: SizedBox(
                                            child:  Padding (
                                              padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
                                              child: ExpansionTile(
                                                title: Row(
                                                  children: [
                                                    Builder(builder: (context) {
                                                      if ( _selectedEvents[index]['alternativeRequired']==true)
                                                      {
                                                        return Container(
                                                          height: size.height * 0.05,
                                                          width: size.width * 0.05,
                                                          decoration: const BoxDecoration(
                                                              color: Colors.redAccent,
                                                              shape: BoxShape.circle
                                                          ),
                                                        );
                                                      }
                                                      else if (_selectedEvents[index]['followedCorrectly']==true) {
                                                        return  Container(
                                                          height: size.height * 0.05,
                                                          width: size.width * 0.05,
                                                          decoration: const BoxDecoration(
                                                              color: Colors.greenAccent,
                                                              shape: BoxShape.circle
                                                          ),
                                                        );
                                                      }
                                                      else {
                                                        return  Container(
                                                          height: size.height * 0.05,
                                                          width: size.width * 0.05,
                                                          decoration: const BoxDecoration(
                                                              color: Colors.grey,
                                                              shape: BoxShape.circle
                                                          ),
                                                        );
                                                      }
                                                    }),
                                                    const SizedBox(width: 5),
                                                    Builder(builder: (context) {
                                                      int num = _selectedEvents[index]['mealOrder'];
                                                      String result = '';
                                                      switch(num) {
                                                        case 0:
                                                          result = "Desayuno:";
                                                          break;
                                                        case 1:
                                                          result = "Comida:";
                                                          break;
                                                        case 2:
                                                          result = "Cena:";
                                                          break;
                                                      }
                                                      return Text("$result ${_selectedEvents[index]['dishName']} ");
                                                    }),
                                                    const SizedBox(width: 10),
                                                  ],
                                                ),
                                                children: [
                                                   if(_selectedEvents[index]['note']!=null)
                                                     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                       Text(_selectedEvents[index]['note'], style: TextStyle(color: Colors.red,))
                                                     ],
                                                     ),


                                                  if(_selectedEvents[index]['followedCorrectly']!=true&&_selectedEvents[index]['alternativeRequired']==false)
                                                  ListTile(
                                                    leading: const Text("Confirmar consumo"),
                                                    trailing: IconButton(onPressed: () async {
                                                      loadingDialog(context);
                                                      String id = "${_focusedDay.day}-${_focusedDay.month}-${_focusedDay.year}_${_selectedEvents[index]['diet']}_${_selectedEvents[index]['mealOrder'].toString()}";
                                                      String? result = await _controllerMeals.confirmConsumption(id);
                                                      if(context.mounted)
                                                        {
                                                          Navigator.pop(context);
                                                          if (result!=null)
                                                            {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                 SnackBar(content: Text(result)),
                                                              );
                                                            }
                                                        }
                                                    }, icon: const Icon(Icons.check_box_sharp),),
                                                  ),
                                                  if(_selectedEvents[index]['followedCorrectly']!=true)
                                                  ListTile(leading:  const Text("Notificar problema"),
                                                    trailing: IconButton(onPressed: () async {

                                                      showDialog(context: context, builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text("Notifica tu problema"),
                                                          content: SizedBox(
                                                                child: TextFormField(
                                                                controller: _problemController,
                                                                textInputAction: TextInputAction.newline,
                                                                keyboardType: TextInputType.multiline,
                                                                minLines: null,
                                                                maxLines: null,
                                                                decoration: const InputDecoration(
                                                                  border: OutlineInputBorder(),
                                                                ),
                                                              ),
                                                          ),
                                                          actions: <Widget> [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text('Cancelar'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () async {
                                                                loadingDialog(context);
                                                                String id = "${_focusedDay.day}-${_focusedDay.month}-${_focusedDay.year}_${_selectedEvents[index]['diet']}_${_selectedEvents[index]['mealOrder'].toString()}";
                                                                String? result;
                                                                if(_problemController.text!="") {
                                                                   result = await _controllerMeals.writeNote(id, _problemController.text);
                                                                } else {
                                                                   result = await _controllerMeals.writeNote(id, "Este plato no se ha podido consumir correctamente");
                                                                }
                                                                if(context.mounted)
                                                                {
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                  if (result!=null)
                                                                  {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                       SnackBar(content: Text(result)),
                                                                    );
                                                                  }
                                                                }
                                                              },
                                                              child: const Text('Aceptar'),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      );
                                                    }, icon: const Icon(Icons.cancel_sharp),),
                                                  ),
                                                  ListTile(leading:  const Text("Receta: "),
                                                    trailing: IconButton(onPressed: () async {

                                                      DocumentSnapshot? result = await _controllerDishes.retrieveDishForUser(_selectedEvents[index]['dish']);

                                                      if(result!=null)
                                                        {
                                                          Map<String, dynamic>? p = result.data() as Map<String, dynamic>?;

                                                          if(context.mounted) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) =>
                                                                    ShowRecipe(dishValues: p!['nutritionalInfo'],
                                                                        dishIngredients: p['ingredients'],
                                                                        dishName: p['name'],
                                                                        dishInstructions: p['description'],
                                                                        dishImage: p['image'],
                                                                        dishUser: p['user'],
                                                                        dishID: result.id))
                                                            );
                                                          }
                                                        }
                                                      if(context.mounted)
                                                      {

                                                        if (result == null)
                                                        {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(content: Text("Ha ocurrido un error")),
                                                          );
                                                        }
                                                      }
                                                    }, icon: const Icon(Icons.arrow_circle_right_sharp),),
                                                  )
                                                ],
                                              ),
                                            )

                                        )

                                    );
                                  }) else const Text('No hay platos asignados a este día'),
                            ],
                          );
                        }
                    )
                )
            )
        )
    );
  }
}