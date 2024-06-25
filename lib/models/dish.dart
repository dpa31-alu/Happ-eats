import 'package:cloud_firestore/cloud_firestore.dart';

class DishModel {
  final String uid;
  final String user;
  final String? image;
  final String name;
  final String description;
  final Map<String, dynamic> nutritionalInfo;
  final Map<String, dynamic> ingredients;

//<editor-fold desc="Data Methods">
  const DishModel({
    required this.uid,
    required this.user,
     this.image,
    required this.name,
    required this.description,
    required this.nutritionalInfo,
    required this.ingredients,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is DishModel &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              user == other.user &&
              image == other.image &&
              name == other.name &&
              description == other.description &&
              nutritionalInfo == other.nutritionalInfo &&
              ingredients == other.ingredients);

  @override
  int get hashCode =>
      uid.hashCode ^
      user.hashCode ^
      image.hashCode ^
      name.hashCode ^
      description.hashCode ^
      nutritionalInfo.hashCode ^
      ingredients.hashCode;

  @override
  String toString() {
    return 'DishModel{' +
        ' uid: $uid,' +
        ' user: $user,' +
        ' image: $image,' +
        ' name: $name,' +
        ' description: $description,' +
        ' nutritionalInfo: $nutritionalInfo,' +
        ' ingredients: $ingredients,' +
        '}';
  }

  DishModel copyWith({
    String? uid,
    String? user,
    String? image,
    String? file,
    String? name,
    String? description,
    Map<String, dynamic>? nutritionalInfo,
    Map<String, dynamic>? ingredients,
  }) {
    return DishModel(
      uid: uid ?? this.uid,
      user: user ?? this.user,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'user': user,
      'image': image,
      'name': name,
      'description': description,
      'nutritionalInfo': nutritionalInfo,
      'ingredients': ingredients,
    };
  }

  factory DishModel.fromMap(Map<String, dynamic> map) {
    return DishModel(
      uid: map['uid'] as String,
      user: map['user'] as String,
      image: map['image'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      nutritionalInfo: map['nutritionalInfo'] as Map<String, dynamic>,
      ingredients: map['ingredients'] as Map<String, dynamic>,
    );
  }

//</editor-fold>


}

class DishRepository {

  final FirebaseFirestore db;

  DishRepository({required this.db});

  Future<WriteBatch> createDish(WriteBatch batch, String id, String user, String dishName, String description,
      Map<String, dynamic> nutritionalInfo, String? imageName, Map<String, dynamic> ingredientes) async {

    batch.set(db.collection('dishes')
        .doc(id), {
      'user': user,
      'name': dishName,
      'description': description,
      'image':imageName,
      'nutritionalInfo': nutritionalInfo,
      'ingredients': ingredientes,
    });

    return batch;

  }

  Future<WriteBatch> deleteDish(WriteBatch batch, String uid) async {
    batch.delete(db.collection('dishes').doc(uid));
    return batch;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllDishes(int amount, String id) {
    return db.collection('dishes').where('user', isEqualTo: id).limit(amount).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDish(String id) {
    return db.collection('dishes').doc(id).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllDishesFuture(String id) async {
     return db.collection('dishes').where('user', isEqualTo: id).get();
  }

}