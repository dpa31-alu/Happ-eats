

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/dish_controller.dart';
import 'package:happ_eats/controllers/ingredient_controller.dart';

import '../models/dish.dart';
import '../models/ingredient.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/file_service.dart';
import '../utils/loading_dialog.dart';
import '../utils/validators.dart';


class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  DictionaryState createState() {
    return DictionaryState();
  }
}

class DictionaryState extends State<Dictionary> {


  List<Map<String, dynamic>> _retrievedIngredients  = [];
  List<Map<String, dynamic>> _filteredIngredients = [];
  final List<Map<String, dynamic>> _addedIngredients = [];

  Map<String, dynamic> _focusedIngredient = {};


  final List<String> _ingredientsOrder = ['Calorías (kcal)',
    'Proteínas (g)',
    'Lípidos totales (g)',
    'AG saturados (g)',
    'AG monoinsaturados (g)',
    'AG poliinsaturados (g)',
    'Omega-3 (g)',
    'C18:2 Linoleico (omega-6) (g)',
    'Colesterol (mg/1000 kcal)',
    'Hidratos de carbono (g)',
    'Fibra (g)',
    'Agua (g)',

    'Calcio (mg)',
    'Hierro (mg)',
    'Yodo (µg)',
    'Magnesio (mg)',
    'Zinc (mg)',
    'Sodio (mg)',
    'Potasio (mg)',
    'Fósforo (mg)',
    'Selenio (μg)',

    'Tiamina (mg)',
    'Riboflavina (mg)',
    'Equivalentes niacina (mg)',
    'Vitamina B6 (mg)',
    'Folatos (μg)',
    'Vitamina B12 (μg)',
    'Vitamina C (mg)',
    'Vitamina A: Eq. Retinol (μg)',
    'Vitamina D (μg)',
    'Vitamina E (mg)',
    'trazas'];

  final _formKey = GlobalKey<FormState>();

  final _dishName = TextEditingController();
  final _dishInstructions = TextEditingController();
  Map<String, dynamic> _dishValues = {};
  Map<String, dynamic> _dishIngredients = {};
  FilePickerResult? _filePicked;



  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String _typeSelected = '1';

  bool _alreadyRead = false;

  IngredientsController controllerIngredient = IngredientsController(db: FirebaseFirestore.instance, repositoryIngredient: IngredientRepository(db: FirebaseFirestore.instance));

  final DishesController controllerDish = DishesController(db: FirebaseFirestore.instance,
      auth: AuthService(auth: FirebaseAuth.instance,),
      file: FileService(storage: FirebaseStorage.instance, auth: AuthService(auth: FirebaseAuth.instance,)),
      repositoryUser: UserRepository(db: FirebaseFirestore.instance),
      repositoryDish: DishRepository(db: FirebaseFirestore.instance));

  Future<List<Map<String, dynamic>>?>? _stateApplication;

  @override
  initState()  {
    _stateApplication = controllerIngredient.retrieveAllIngredients();

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
        key : _key,
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back),),
            title: const Text("Happ-eats"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Setting Icon',
                onPressed: () {},
              ),
            ]
        ),
        drawerEnableOpenDragGesture: false,
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            _key.currentState!.openEndDrawer();
          },
          child: const Icon(Icons.draw_sharp),
        ),
        drawer: (_focusedIngredient.isNotEmpty)
            ? SingleChildScrollView(
              child: SafeArea(
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0, top: 10.0),
                        child: Column(
                          children: [
                            Padding(padding:  const EdgeInsets.only(bottom: 10.0),
                            child: Text(_focusedIngredient['name'],  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25,),),
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              height: size.height * 0.8,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _focusedIngredient.length-1,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      const Divider(
                                        height: 2.0,
                                      ),
                                      ListTile(
                                        title: Text(_ingredientsOrder[index]),
                                        subtitle: Text(_focusedIngredient[_ingredientsOrder[index]].toString()),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ),
              ),
        ): const Text('Seleccione un ingrediente'),
        endDrawer: (_addedIngredients.isNotEmpty)
            ? SingleChildScrollView(
                child: SafeArea(
                    child: Center(
                      child: Form(
                        key: _formKey,
                          child: Column(
                            children: [
                              const Padding(padding:  EdgeInsets.only(bottom: 10.0),
                                child: Text("Constuye tu plato:",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,),),
                              ),
                              SizedBox(
                                width: size.width * 0.9,
                                child: Card(
                                  child: TextFormField(
                                    controller: _dishName,
                                    validator: (value) {
                                      return validateDishName(value);
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Nombre del plato',
                                    ),
                                  ),

                                ),
                              ),
                              ListView.builder(
                                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                shrinkWrap: true,
                                itemCount: _addedIngredients.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child:  ExpansionTile(
                                      title: Text("${_addedIngredients[index]["name"].toString()} - Cantidad en g/ml: "),
                                      subtitle:  TextFormField(
                                        initialValue: "100",
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {

                                          _dishIngredients[_addedIngredients[index]["name"]] = value;

                                          for(int i = 0; i < _addedIngredients[index].length - 1; i++){
                                            String key = _ingredientsOrder[i];
                                            double newValue;

                                            if(_addedIngredients[index][key] is String) {
                                              newValue = 0.0;
                                            }
                                            else{
                                              newValue = _addedIngredients[index][key].toDouble();
                                            }

                                            if(_dishValues[key]==null) {

                                              _dishValues[key] =   (newValue * double.parse(value!) /  100);
                                            }
                                            else {
                                              _dishValues[key] =  _dishValues[key] + (newValue * double.parse(value!) /  100);
                                            }
                                          }

                                        },
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                          title: const Center( child: Text("Quitar ingrediente")),
                                          subtitle: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _addedIngredients.remove(_addedIngredients[index]);
                                              });
                                            },
                                            child: const Icon(Icons.remove_circle_sharp, size: 30,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                width: size.width * 0.9,
                                height: size.height * 0.2,
                                child:  Card(
                                    child: TextFormField(
                                      validator: (value) {
                                        return validateInstructions(value);
                                      },
                                      controller: _dishInstructions,
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      minLines: null,
                                      maxLines: null,
                                      expands: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Instrucciones',
                                      ),
                                    ),
                                ),
                              ),
                              SizedBox(
                                  width: size.width * 0.6,
                                    child: Card(
                                        child: TextButton.icon(
                                            onPressed: () async {
                                              loadingDialog(context);
                                              _filePicked = await controllerDish.getImage();
                                              if(context.mounted) {
                                                Navigator.pop(context);
                                              }

                                              if(_filePicked==null&&context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(content: Text(
                                                      "Error en la asignación")),
                                                );
                                              }
                                            },
                                            icon: IconButton(onPressed: () {}, icon: const Icon(Icons.image_search_sharp)),
                                            label: const Text("Seleccione una imagen (opcional)"),
                                        )
                                    ),
                              ),
                              ElevatedButton(onPressed: () async {

                                if(_formKey.currentState!.validate())
                                  {

                                    _formKey.currentState!.save();

                                    return showDialog(context: context, builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirmación"),
                                        content: const Text("¿Desea crear este plato?"),
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
                                              String? result = await controllerDish.createDish(_dishName.text, _dishInstructions.text, _dishValues, _filePicked, _dishIngredients);
                                              if(context.mounted) {
                                                  Navigator.pop(context);
                                                }

                                              if(result!=null&&context.mounted) {
                                                Navigator.pop(context);
                                                _key.currentState!.closeEndDrawer();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Error en la asignación")),
                                                );
                                              }

                                              if(context.mounted) {
                                                Navigator.pop(context);
                                                _key.currentState!.closeEndDrawer();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Plato creado correctamente")),
                                                );
                                              }

                                              _dishValues = {};
                                              _dishIngredients = {};
                                              _filePicked = null;

                                            },
                                            child: const Text('Aceptar'),
                                          ),
                                        ],
                                      );
                                    }
                                    );
                                  }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Complete el formulario correctamente")),
                                  );
                                }

                              }, child: const Text("Crear plato"))
                            ],
                          )
                      ),
                    )
                ),

          )
            :  Padding(
            padding: const EdgeInsets.only(top: 10.0,bottom: 10, right: 10),
            child: Container(
              alignment: Alignment.center,
              child: const Text('Crea un plato, añade ingredientes',
                style: TextStyle(fontSize: 20),
              ),
            )
        ),
        body: SafeArea(
            child: Column(
                children: [
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          FutureBuilder <List<Map<String, dynamic>>?>(
                              future:  _stateApplication,
                              builder: (BuildContext context, map) {
                                if (map.connectionState == ConnectionState.waiting)
                                {
                                  return  Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.35,
                                      ),
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    ],);
                                }
                                else if (map.data == null)
                                  {
                                    return const Column(
                                      children: [
                                        Center(
                                          child: Text("Ha ocurrido un error durante la carga de datos"),
                                        )
                                    ],);
                                  }
                                else {
                                   _retrievedIngredients  = map.data!;
                                   if (_filteredIngredients.isEmpty&&!_alreadyRead)
                                     {
                                       _filteredIngredients = _retrievedIngredients;
                                       _alreadyRead = true;
                                     }
                                  return Column(
                                    children: [
                                      const Text("Busca y Filtra Ingredientes,", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,),),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: size.width * 0.8,
                                        child: TextFormField(
                                          onChanged: (name) {
                                            setState(() {
                                              if(name.isEmpty){
                                                _filteredIngredients = _retrievedIngredients;
                                              } else {
                                                _filteredIngredients = _retrievedIngredients.where((map) => map["name"].toLowerCase().contains(name.toLowerCase())).toList();
                                              }
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Introduce un alimento',
                                            suffixIcon: Icon(Icons.search_sharp),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      DropdownButton(
                                        value: _typeSelected,
                                        items: const [
                                          DropdownMenuItem<String>(value: '1', child: Text('Ordena por macronutrientes')),
                                          DropdownMenuItem<String>(value: 'Calorías (kcal)', child: Text('Calorías')),
                                          DropdownMenuItem<String>(value: 'Proteínas (g)', child: Text('Proteínas')),
                                          DropdownMenuItem<String>(value: 'Lípidos totales (g)', child: Text('Grasas totales')),
                                          DropdownMenuItem<String>(value: 'AG saturados (g)', child: Text('Grasas saturadas')),
                                          DropdownMenuItem<String>(value: 'AG monoinsaturados (g)', child: Text('Grasas monoinsaturadas')),
                                          DropdownMenuItem<String>(value: 'AG poliinsaturados (g)', child: Text('Grasas polinsaturadas')),
                                          DropdownMenuItem<String>(value: 'Omega-3 (g)', child: Text('Omega 3')),
                                          DropdownMenuItem<String>(value: 'C18:2 Linoleico (omega-6) (g)', child: Text('Ácido linoleico')),
                                          DropdownMenuItem<String>(value: 'Colesterol (mg/1000 kcal)', child: Text('Colesterol')),
                                          DropdownMenuItem<String>(value: 'Hidratos de carbono (g)', child: Text('Carbohidratos totales')),
                                          DropdownMenuItem<String>(value: 'Fibra (g)', child: Text('Fibra')),
                                          DropdownMenuItem<String>(value: 'Agua (g)', child: Text('Agua')),
                                          DropdownMenuItem<String>(value: 'Calcio (mg)', child: Text('calcio')),
                                          DropdownMenuItem<String>(value: 'Hierro (mg)', child: Text('Hierro')),
                                          DropdownMenuItem<String>(value: 'Yodo (µg)', child: Text('Yodo')),
                                          DropdownMenuItem<String>(value: 'Magnesio (mg)', child: Text('Magnesio')),
                                          DropdownMenuItem<String>(value: 'Zinc (mg)', child: Text('Zinc')),
                                          DropdownMenuItem<String>(value: 'Sodio (mg)', child: Text('Sodio')),
                                          DropdownMenuItem<String>(value: 'Potasio (mg)', child: Text('Potasio')),
                                          DropdownMenuItem<String>(value: 'Fósforo (mg)', child: Text('Fósforo')),
                                          DropdownMenuItem<String>(value: 'Selenio (μg)', child: Text('Selenio')),
                                          DropdownMenuItem<String>(value: 'Tiamina (mg)', child: Text('Tiamina')),
                                          DropdownMenuItem<String>(value: 'Riboflavina (mg)', child: Text('Riboflavina')),
                                          DropdownMenuItem<String>(value: 'Equivalentes niacina (mg)', child: Text('Niacina')),
                                          DropdownMenuItem<String>(value: 'Vitamina B6 (mg)', child: Text('Vitamina B6')),
                                          DropdownMenuItem<String>(value: 'Folatos (μg)', child: Text('Folatos')),
                                          DropdownMenuItem<String>(value: 'Vitamina B12 (μg)', child: Text('Vitamina B12')),
                                          DropdownMenuItem<String>(value: 'Vitamina C (mg)', child: Text('Vitamina C')),
                                          DropdownMenuItem<String>(value: 'Vitamina A: Eq. Retinol (μg)', child: Text('Vitamina A')),
                                          DropdownMenuItem<String>(value: 'Vitamina D (μg)', child: Text('Vitamina D')),
                                          DropdownMenuItem<String>(value: 'Vitamina E (mg)', child: Text('Vitamina E')),
                                        ],
                                        onChanged: (String? value) {
                                          setState(() {
                                            _typeSelected = value!;
                                            if(value.isNotEmpty) {
                                              _filteredIngredients.sort((a, b) => (b[value]).compareTo(a[value]));
                                            }
                                            else {
                                              _filteredIngredients = _retrievedIngredients;
                                            }
                                          });
                                        },
                                      ),

                                      (_filteredIngredients.isNotEmpty)
                                          ? ListView.builder(
                                        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                        shrinkWrap: true,
                                        itemCount: _filteredIngredients.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            child:  ListTile(
                                              onTap: () {
                                                setState(() {
                                                  _focusedIngredient = _filteredIngredients[index];
                                                  _key.currentState!.openDrawer();
                                                });
                                              },
                                              title: Text(_filteredIngredients[index]["name"].toString()),
                                              trailing: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if(!_addedIngredients.contains(_filteredIngredients[index])) {
                                                      _addedIngredients.add(_filteredIngredients[index]);
                                                    }
                                                  });
                                                },
                                                child: const Icon(Icons.add_circle_sharp  , size: 30,),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                          :  const Text('No hay resultados',
                                        style: TextStyle(fontSize: 20),),
                                    ],
                                  );
                                }
                              }),
                        ]
                    ) ,
                ),
               ]
            )
        )
    );
  }

}