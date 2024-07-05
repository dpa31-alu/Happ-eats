import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientModel {
  final String uid;
  final String name;
  final double calories;
  final double totalFats;
  final double monounsaturatedFats;
  final double polyunsaturatedFats;
  final double saturatedFats;
  final double totalCarbohydrates;
  final double sugar;
  final double polyalcohols;
  final double starch;
  final double fiber;
  final double protein;
  final double salt;
  final double vitaminA;
  final double vitaminD;
  final double vitaminE;
  final double vitaminK;
  final double vitaminC;
  final double thiamine;
  final double riboflavin;
  final double niacin;
  final double vitaminB6;
  final double folicAcid;
  final double vitaminB12;
  final double biotin;
  final double pantothenicAcid;
  final double potassium;
  final double chloride;
  final double calcium;
  final double phosphorus;
  final double magnesium;
  final double iron;
  final double zinc;
  final double copper;
  final double manganese;
  final double fluoride;
  final double selenium;
  final double chrome;
  final double molybdenum;
  final double iodine;



//<editor-fold desc="Data Methods">


  const IngredientModel({
    required this.uid,
    required this.name,
    required this.calories,
    required this.totalFats,
    required this.monounsaturatedFats,
    required this.polyunsaturatedFats,
    required this.saturatedFats,
    required this.totalCarbohydrates,
    required this.sugar,
    required this.polyalcohols,
    required this.starch,
    required this.fiber,
    required this.protein,
    required this.salt,
    required this.vitaminA,
    required this.vitaminD,
    required this.vitaminE,
    required this.vitaminK,
    required this.vitaminC,
    required this.thiamine,
    required this.riboflavin,
    required this.niacin,
    required this.vitaminB6,
    required this.folicAcid,
    required this.vitaminB12,
    required this.biotin,
    required this.pantothenicAcid,
    required this.potassium,
    required this.chloride,
    required this.calcium,
    required this.phosphorus,
    required this.magnesium,
    required this.iron,
    required this.zinc,
    required this.copper,
    required this.manganese,
    required this.fluoride,
    required this.selenium,
    required this.chrome,
    required this.molybdenum,
    required this.iodine,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is IngredientModel &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              name == other.name &&
              calories == other.calories &&
              totalFats == other.totalFats &&
              monounsaturatedFats == other.monounsaturatedFats &&
              polyunsaturatedFats == other.polyunsaturatedFats &&
              saturatedFats == other.saturatedFats &&
              totalCarbohydrates == other.totalCarbohydrates &&
              sugar == other.sugar &&
              polyalcohols == other.polyalcohols &&
              starch == other.starch &&
              fiber == other.fiber &&
              protein == other.protein &&
              salt == other.salt &&
              vitaminA == other.vitaminA &&
              vitaminD == other.vitaminD &&
              vitaminE == other.vitaminE &&
              vitaminK == other.vitaminK &&
              vitaminC == other.vitaminC &&
              thiamine == other.thiamine &&
              riboflavin == other.riboflavin &&
              niacin == other.niacin &&
              vitaminB6 == other.vitaminB6 &&
              folicAcid == other.folicAcid &&
              vitaminB12 == other.vitaminB12 &&
              biotin == other.biotin &&
              pantothenicAcid == other.pantothenicAcid &&
              potassium == other.potassium &&
              chloride == other.chloride &&
              calcium == other.calcium &&
              phosphorus == other.phosphorus &&
              magnesium == other.magnesium &&
              iron == other.iron &&
              zinc == other.zinc &&
              copper == other.copper &&
              manganese == other.manganese &&
              fluoride == other.fluoride &&
              selenium == other.selenium &&
              chrome == other.chrome &&
              molybdenum == other.molybdenum &&
              iodine == other.iodine
          );


  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      calories.hashCode ^
      totalFats.hashCode ^
      monounsaturatedFats.hashCode ^
      polyunsaturatedFats.hashCode ^
      saturatedFats.hashCode ^
      totalCarbohydrates.hashCode ^
      sugar.hashCode ^
      polyalcohols.hashCode ^
      starch.hashCode ^
      fiber.hashCode ^
      protein.hashCode ^
      salt.hashCode ^
      vitaminA.hashCode ^
      vitaminD.hashCode ^
      vitaminE.hashCode ^
      vitaminK.hashCode ^
      vitaminC.hashCode ^
      thiamine.hashCode ^
      riboflavin.hashCode ^
      niacin.hashCode ^
      vitaminB6.hashCode ^
      folicAcid.hashCode ^
      vitaminB12.hashCode ^
      biotin.hashCode ^
      pantothenicAcid.hashCode ^
      potassium.hashCode ^
      chloride.hashCode ^
      calcium.hashCode ^
      phosphorus.hashCode ^
      magnesium.hashCode ^
      iron.hashCode ^
      zinc.hashCode ^
      copper.hashCode ^
      manganese.hashCode ^
      fluoride.hashCode ^
      selenium.hashCode ^
      chrome.hashCode ^
      molybdenum.hashCode ^
      iodine.hashCode;


  @override
  String toString() {
    return 'IngredientModel{' +
        ' uid: $uid,' +
        ' name: $name,' +
        ' calories: $calories,' +
        ' totalFats: $totalFats,' +
        ' monounsaturatedFats: $monounsaturatedFats,' +
        ' polyunsaturatedFats: $polyunsaturatedFats,' +
        ' saturatedFats: $saturatedFats,' +
        ' totalCarbohydrates: $totalCarbohydrates,' +
        ' sugar: $sugar,' +
        ' polyalcohols: $polyalcohols,' +
        ' starch: $starch,' +
        ' fiber: $fiber,' +
        ' protein: $protein,' +
        ' salt: $salt,' +
        ' vitaminA: $vitaminA,' +
        ' vitaminD: $vitaminD,' +
        ' vitaminE: $vitaminE,' +
        ' vitaminK: $vitaminK,' +
        ' vitaminC: $vitaminC,' +
        ' thiamine: $thiamine,' +
        ' riboflavin: $riboflavin,' +
        ' niacin: $niacin,' +
        ' vitaminB6: $vitaminB6,' +
        ' folicAcid: $folicAcid,' +
        ' vitaminB12: $vitaminB12,' +
        ' biotin: $biotin,' +
        ' pantothenicAcid: $pantothenicAcid,' +
        ' potassium: $potassium,' +
        ' chloride: $chloride,' +
        ' calcium: $calcium,' +
        ' phosphorus: $phosphorus,' +
        ' magnesium: $magnesium,' +
        ' iron: $iron,' +
        ' zinc: $zinc,' +
        ' copper: $copper,' +
        ' manganese: $manganese,' +
        ' fluoride: $fluoride,' +
        ' selenium: $selenium,' +
        ' chrome: $chrome,' +
        ' molybdenum: $molybdenum,' +
        ' iodine: $iodine,' +
        '}';
  }


  IngredientModel copyWith({
    String? uid,
    String? name,
    double? calories,
    double? totalFats,
    double? monounsaturatedFats,
    double? polyunsaturatedFats,
    double? saturatedFats,
    double? totalCarbohydrates,
    double? sugar,
    double? polyalcohols,
    double? starch,
    double? fiber,
    double? protein,
    double? salt,
    double? vitaminA,
    double? vitaminD,
    double? vitaminE,
    double? vitaminK,
    double? vitaminC,
    double? thiamine,
    double? riboflavin,
    double? niacin,
    double? vitaminB6,
    double? folicAcid,
    double? vitaminB12,
    double? biotin,
    double? pantothenicAcid,
    double? potassium,
    double? chloride,
    double? calcium,
    double? phosphorus,
    double? magnesium,
    double? iron,
    double? zinc,
    double? copper,
    double? manganese,
    double? fluoride,
    double? selenium,
    double? chrome,
    double? molybdenum,
    double? iodine,
  }) {
    return IngredientModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      totalFats: totalFats ?? this.totalFats,
      monounsaturatedFats: monounsaturatedFats ?? this.monounsaturatedFats,
      polyunsaturatedFats: polyunsaturatedFats ?? this.polyunsaturatedFats,
      saturatedFats: saturatedFats ?? this.saturatedFats,
      totalCarbohydrates: totalCarbohydrates ?? this.totalCarbohydrates,
      sugar: sugar ?? this.sugar,
      polyalcohols: polyalcohols ?? this.polyalcohols,
      starch: starch ?? this.starch,
      fiber: fiber ?? this.fiber,
      protein: protein ?? this.protein,
      salt: salt ?? this.salt,
      vitaminA: vitaminA ?? this.vitaminA,
      vitaminD: vitaminD ?? this.vitaminD,
      vitaminE: vitaminE ?? this.vitaminE,
      vitaminK: vitaminK ?? this.vitaminK,
      vitaminC: vitaminC ?? this.vitaminC,
      thiamine: thiamine ?? this.thiamine,
      riboflavin: riboflavin ?? this.riboflavin,
      niacin: niacin ?? this.niacin,
      vitaminB6: vitaminB6 ?? this.vitaminB6,
      folicAcid: folicAcid ?? this.folicAcid,
      vitaminB12: vitaminB12 ?? this.vitaminB12,
      biotin: biotin ?? this.biotin,
      pantothenicAcid: pantothenicAcid ?? this.pantothenicAcid,
      potassium: potassium ?? this.potassium,
      chloride: chloride ?? this.chloride,
      calcium: calcium ?? this.calcium,
      phosphorus: phosphorus ?? this.phosphorus,
      magnesium: magnesium ?? this.magnesium,
      iron: iron ?? this.iron,
      zinc: zinc ?? this.zinc,
      copper: copper ?? this.copper,
      manganese: manganese ?? this.manganese,
      fluoride: fluoride ?? this.fluoride,
      selenium: selenium ?? this.selenium,
      chrome: chrome ?? this.chrome,
      molybdenum: molybdenum ?? this.molybdenum,
      iodine: iodine ?? this.iodine,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'calories': calories,
      'totalFats': totalFats,
      'monounsaturatedFats': monounsaturatedFats,
      'polyunsaturatedFats': polyunsaturatedFats,
      'saturatedFats': saturatedFats,
      'totalCarbohydrates': totalCarbohydrates,
      'sugar': sugar,
      'polyalcohols': polyalcohols,
      'starch': starch,
      'fiber': fiber,
      'protein': protein,
      'salt': salt,
      'vitaminA': vitaminA,
      'vitaminD': vitaminD,
      'vitaminE': vitaminE,
      'vitaminK': vitaminK,
      'vitaminC': vitaminC,
      'thiamine': thiamine,
      'riboflavin': riboflavin,
      'niacin': niacin,
      'vitaminB6': vitaminB6,
      'folicAcid': folicAcid,
      'vitaminB12': vitaminB12,
      'biotin': biotin,
      'pantothenicAcid': pantothenicAcid,
      'potassium': potassium,
      'chloride': chloride,
      'calcium': calcium,
      'phosphorus': phosphorus,
      'magnesium': magnesium,
      'iron': iron,
      'zinc': zinc,
      'copper': copper,
      'manganese': manganese,
      'fluoride': fluoride,
      'selenium': selenium,
      'chrome': chrome,
      'molybdenum': molybdenum,
      'iodine': iodine,
    };
  }

  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      calories: map['calories'] as double,
      totalFats: map['totalFats'] as double,
      monounsaturatedFats: map['monounsaturatedFats'] as double,
      polyunsaturatedFats: map['polyunsaturatedFats'] as double,
      saturatedFats: map['saturatedFats'] as double,
      totalCarbohydrates: map['totalCarbohydrates'] as double,
      sugar: map['sugar'] as double,
      polyalcohols: map['polyalcohols'] as double,
      starch: map['starch'] as double,
      fiber: map['fiber'] as double,
      protein: map['protein'] as double,
      salt: map['salt'] as double,
      vitaminA: map['vitaminA'] as double,
      vitaminD: map['vitaminD'] as double,
      vitaminE: map['vitaminE'] as double,
      vitaminK: map['vitaminK'] as double,
      vitaminC: map['vitaminC'] as double,
      thiamine: map['thiamine'] as double,
      riboflavin: map['riboflavin'] as double,
      niacin: map['niacin'] as double,
      vitaminB6: map['vitaminB6'] as double,
      folicAcid: map['folicAcid'] as double,
      vitaminB12: map['vitaminB12'] as double,
      biotin: map['biotin'] as double,
      pantothenicAcid: map['pantothenicAcid'] as double,
      potassium: map['potassium'] as double,
      chloride: map['chloride'] as double,
      calcium: map['calcium'] as double,
      phosphorus: map['phosphorus'] as double,
      magnesium: map['magnesium'] as double,
      iron: map['iron'] as double,
      zinc: map['zinc'] as double,
      copper: map['copper'] as double,
      manganese: map['manganese'] as double,
      fluoride: map['fluoride'] as double,
      selenium: map['selenium'] as double,
      chrome: map['chrome'] as double,
      molybdenum: map['molybdenum'] as double,
      iodine: map['iodine'] as double,
    );
  }


//</editor-fold>


}

class IngredientRepository{

  final FirebaseFirestore db;

  IngredientRepository({required this.db});

  /// Retrieves all the ingredients from the database
  /// Modifies them to be manageable
  /// Returns a query snapshot
  Future<QuerySnapshot<Map<String, dynamic>>> getAllIngredients() {
    return db.collection('ingredients').get();
  }


}