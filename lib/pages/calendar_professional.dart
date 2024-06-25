import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/appointed_meal_controller.dart';
import 'package:happ_eats/controllers/user_controller.dart';
import 'package:happ_eats/pages/recipe.dart';
import 'package:happ_eats/utils/loading_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/dish_controller.dart';
import '../models/appointed_meal.dart';
import '../models/dish.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/file_service.dart';


class CalendarProfessional extends StatefulWidget {

  final String dietID;
  final String professional;
  final String patient;

  const CalendarProfessional({super.key, required this.dietID, required this.professional, required this.patient});

  @override
  CalendarProfessionalState createState() {
    return CalendarProfessionalState();
  }
}

class CalendarProfessionalState extends State<CalendarProfessional> {

  final _formKey = GlobalKey<FormState>();

  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? _selectedDay;

  final AppointedMealsController _controllerMeals = AppointedMealsController(db: FirebaseFirestore.instance, repositoryDish: DishRepository(db: FirebaseFirestore.instance), repositoryAppointedMeal: AppointedMealRepository(db: FirebaseFirestore.instance));

  final UsersController _controllerUsers = UsersController(db: FirebaseFirestore.instance, auth: AuthService(auth: FirebaseAuth.instance,));

  final DishesController _controllerDishes = DishesController(db: FirebaseFirestore.instance,
      auth: AuthService(auth: FirebaseAuth.instance,),
      file: FileService(storage: FirebaseStorage.instance, auth: AuthService(auth: FirebaseAuth.instance,)),
      repositoryUser: UserRepository(db: FirebaseFirestore.instance),
      repositoryDish: DishRepository(db: FirebaseFirestore.instance));

  late Map<DateTime, List<Map<String, dynamic>>> _events;

  late Stream<QuerySnapshot> _stateEvents;

  List<Map<String, dynamic>> _selectedEvents = [];

  Map<String, dynamic>? _userDishes = {};

  String _typeSelected = '';

  @override
  void initState() {

    _dishesLoader();

    //_stateEvents = _controllerMeals.retrieveAllDishesForUserStream(_findNearestMonday(_focusedDay), _findNearestSunday(_focusedDay), widget.dietID);

    //_eventsLoader();

    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: generateHash
    );

    super.initState();
  }

  _dishesLoader() async {
    Map<String, dynamic>? dishesRetrieved = await _controllerUsers.getUserDishes();
    setState(() {
      _userDishes = dishesRetrieved;
    });
  }

  /*_eventsLoader() async {

      QuerySnapshot<Map<String, dynamic>> result = await _controllerMeals.retrieveAllDishesForUser(_findNearestMonday(_focusedDay), _findNearestSunday(_focusedDay), widget.dishID);

      for (DocumentSnapshot<Map<String, dynamic>> a in result.docs)
        {
          Map<String, dynamic>? p = a.data();
          DateTime date = a['appointedDate'];
          DateTime day = DateTime.utc(date.year, date.month, date.day);
          if (_events[day] == null)
            {
              _events[day] = [];
            }
          _events[day]!.add(p!);
          
        }

      setState(() {

    });
  }*/

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
        endDrawerEnableOpenDragGesture: false,
        endDrawer: SafeArea(
          child:
          Column(

            children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: DropdownButtonFormField(
                      value: _typeSelected,
                      items: const [
                        DropdownMenuItem<String>(value: '', child: Text('Seleccione una hora para la comida')),
                        DropdownMenuItem<String>(value: '0', child: Text('Desayuno')),
                        DropdownMenuItem<String>(value: '1', child: Text('Comida')),
                        DropdownMenuItem<String>(value: '2', child: Text('Cena')),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _typeSelected = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                      shrinkWrap: true,
                      itemCount:  _userDishes!.length,
                      itemBuilder: (context, index) {
                        return Card(child: ListTile(
                          leading: Text(_userDishes![_userDishes!.keys.elementAt(index)]),
                          trailing: IconButton(onPressed: () async {
                            if (_typeSelected!='')
                              {
                                loadingDialog(context);
                                DateTime today = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day);
                                String? result = await _controllerMeals.createAppointment(_userDishes![_userDishes!.keys.elementAt(index)],
                                    _userDishes!.keys.elementAt(index), widget.dietID, widget.professional, widget.patient, today, int.parse(_typeSelected));

                                if(context.mounted)
                                  {
                                    Navigator.pop(context);
                                  }
                                if(context.mounted&&result==null) {
                                  _key.currentState!.closeEndDrawer();
                                }
                                if(context.mounted&&result!=null) {
                                  _key.currentState!.closeEndDrawer();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(content: Text(result)),
                                  );
                                }

                              }
                            else {
                              _key.currentState!.closeEndDrawer();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Asigne un momento para el plato.")),
                              );
                            }
                          }, icon: const Icon(Icons.add_alert_sharp),),
                        ),);

                      }),
                  
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.draw_sharp),
            onPressed:  ()  {
              _key.currentState!.openEndDrawer();
            }),
        appBar: AppBar(
          //leading: Icon(Icons.account_circle_rounded),
            title: const Text("Happ-eats"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Setting Icon',
                onPressed: () {},
              ),
            ]
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0,),
                  child:  StreamBuilder (
                            stream: _controllerMeals.retrieveAllDishesForUserStream(_findNearestMonday(_focusedDay), _findNearestSunday(_focusedDay), widget.dietID),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {

                              if (snapshot.hasError) {
                              return  const Center(child: Text("No se han podido recuperar los pacientes"),);
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
                                  (_selectedEvents.isNotEmpty)?
                                      ListView.builder(
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
                                                    if(_selectedEvents[index]['note']!=null)
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        const Text("Nota: "),
                                                        Text(_selectedEvents[index]['note'])],),

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
                                                                      dishImage: p['iamge'],
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
                                      }):  const Text('No hay platos asignados a este día'),
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