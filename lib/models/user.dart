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

  Future<WriteBatch> deleteUser(WriteBatch batch, String uid) async {

    batch.delete(db.collection('users')
        .doc(uid));
    return batch;
    /*
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      */
  }



  /*
  static Future<WriteBatch> updateUserInfo(WriteBatch batch, String uid, String newFirstName, String newLastName, String newTel, String newGender) async {
      batch.update(db.collection('users')
          .doc(uid), {
        'firstName': newFirstName,
        'lastName': newLastName,
        'tel': newTel,
        'gender': newGender,
      });
      return batch;
      /*
      db.collection('users').doc(uid).update(UserModel(firstName: newFirstName, lastName: newLastName, tel: newTel).toMap());
      */
  }*/

  Future<WriteBatch> updateUserTel(WriteBatch batch, String uid, String newTel) async {
    batch.update(db.collection('users')
        .doc(uid), {
      'tel': newTel,
    });
    return batch;
  }

  Future<WriteBatch> updateUserFirstName(WriteBatch batch, String uid, String newFirstName) async {
    batch.update(db.collection('users')
        .doc(uid), {
      'firstName': newFirstName,
    });
    return batch;
  }

  Future<WriteBatch> updateUserLastName(WriteBatch batch, String uid, String newLastName,) async {
    batch.update(db.collection('users')
        .doc(uid), {
      'lastName': newLastName,
    });
    return batch;
  }

  Future<WriteBatch> updateUserGender(WriteBatch batch, String uid, String newGender) async {
    batch.update(db.collection('users')
        .doc(uid), {
      'gender': newGender,
    });
    return batch;
  }


  Future<UserModel> getUser(String uid) async {
    var user = await db.collection('users').doc(uid).get();
    return UserModel.fromDocument(user);
  }

  Future<WriteBatch> addDishes(WriteBatch batch, String id, String user, String dishName) async {
    batch.update(db.collection('users')
        .doc(user), {
      'dishes.$id': dishName,
    });
    return batch;
  }

  Future<WriteBatch> removeDishes(WriteBatch batch, String id, String user) async {
    batch.update(db.collection('users')
        .doc(user), {
      'dishes.$id': FieldValue.delete(),
    });
    return batch;
  }

  /*
   Future<DocumentSnapshot<Map<String, dynamic>>> retrieveDishes(String user) async {
    return db.collection('users').doc(user).get();
  }

   Future<Map<String, dynamic>> retrieveUser(String user) async {
    DocumentSnapshot doc = await db.collection('users').doc(user).get();
    return UserModel.fromDocument(doc).toMap();
  }*/


}
