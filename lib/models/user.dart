import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
   String? user;
   String firstName;
   String lastName;
   String tel;
   String gender;
   Map<String, dynamic>? dishes;

//<editor-fold desc="Data Methods">

  UserModel({
    this.user,
    required this.firstName,
    required this.lastName,
    required this.tel,
    required this.gender,
    this.dishes,
  });

//</e@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is UserModel &&
              runtimeType == other.runtimeType &&
              user == other.user &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              tel == other.tel &&
              gender == other.gender &&
              dishes == other.dishes
          );


  @override
  int get hashCode =>
      user.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      tel.hashCode ^
      gender.hashCode ^
      dishes.hashCode;


  @override
  String toString() {
    return 'UserModel{' +
        ' user: $user,' +
        ' firstName: $firstName,' +
        ' lastName: $lastName,' +
        ' tel: $tel,' +
        ' gender: $gender,' +
        ' dishes: $dishes,' +
        '}';
  }


  UserModel copyWith({
    String? user,
    String? firstName,
    String? lastName,
    String? tel,
    String? gender,
    Map<String, dynamic>? dishes,
  }) {
    return UserModel(
      user: user ?? this.user,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      tel: tel ?? this.tel,
      gender: gender ?? this.gender,
      dishes: dishes ?? this.dishes,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'firstName': firstName,
      'lastName': lastName,
      'tel': tel,
      'gender': gender,
      'dishes': dishes,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user: map['user'] as String?,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      tel: map['tel'] as String,
      gender: map['gender'] as String,
      dishes: map['dishes'] as Map<String, dynamic>?,
    );
  }
  //</editor-fold>


  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserModel.fromMap(data).copyWith(user: doc.id);
  }

}




class UserRepository {

  final FirebaseFirestore db;

  UserRepository({required this.db});


  /// Method for adding a user's creation to a batch
  /// Requires the batch, id, gender, first name, last name and phone number
  /// Returns a write batch
  Future<WriteBatch> createUser(WriteBatch batch, String uid, String newFirstName, String newLastName, String newTel, String newGender) async {
    batch.set(db.collection('users')
        .doc(uid), {
      'firstName': newFirstName,
      'lastName': newLastName,
      'tel': newTel,
      'gender': newGender
    });
    return batch;
  }


  /// Method for adding a user's deletion to a batch
  /// Requires the batch and id
  /// Returns a write batch
  Future<WriteBatch> deleteUser(WriteBatch batch, String uid) async {

    batch.delete(db.collection('users')
        .doc(uid));
    return batch;

  }

  /// Method for adding a user's phone number update to a batch
  /// Requires the batch, id and phone number
  /// Returns a write batch
  Future<WriteBatch> updateUserTel(WriteBatch batch, String uid, String newTel) async {
    batch.update(db.collection('users')
        .doc(uid), {
      'tel': newTel,
    });
    return batch;
  }

  /// Method for adding a user's first name update to a batch
  /// Requires the batch, id and first name
  /// Returns a write batch
  Future<WriteBatch> updateUserFirstName(WriteBatch batch, String uid, String newFirstName) async {
    batch.update(db.collection('users')
        .doc(uid), {
      'firstName': newFirstName,
    });
    return batch;
  }

  /// Method for adding a user's last name update to a batch
  /// Requires the batch, id and last name
  /// Returns a write batch
  Future<WriteBatch> updateUserLastName(WriteBatch batch, String uid, String newLastName,) async {
    batch.update(db.collection('users')
        .doc(uid), {
      'lastName': newLastName,
    });
    return batch;
  }

  /// Method for adding a user's gender update to a batch
  /// Requires the batch, id and gender
  /// Returns a write batch
  Future<WriteBatch> updateUserGender(WriteBatch batch, String uid, String newGender) async {
    batch.update(db.collection('users')
        .doc(uid), {
      'gender': newGender,
    });
    return batch;
  }

  /// Method for retrieving a user's data
  /// Requires the id of the user
  /// Returns a UserModel object
  Future<UserModel> getUser(String uid) async {
    var user = await db.collection('users').doc(uid).get();
    return UserModel.fromDocument(user);
  }

  /// Method for adding a user's dishes update to a batch
  /// Requires the batch, id, dish name, and dish id
  /// Returns a write batch
  Future<WriteBatch> addDishes(WriteBatch batch, String id, String user, String dishName) async {
    batch.update(db.collection('users')
        .doc(user), {
      'dishes.$id': dishName,
    });
    return batch;
  }

  /// Method for adding a user's dishes deletion to a batch
  /// Requires the batch, id, and dish id
  /// Returns a write batch
  Future<WriteBatch> removeDishes(WriteBatch batch, String id, String user) async {
    batch.update(db.collection('users')
        .doc(user), {
      'dishes.$id': FieldValue.delete(),
    });
    return batch;
  }
}
