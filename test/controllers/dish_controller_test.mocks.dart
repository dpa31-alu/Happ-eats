// Mocks generated by Mockito 5.4.4 from annotations
// in happ_eats/test/controllers/dish_controller_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:file_picker/file_picker.dart' as _i10;
import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'package:firebase_storage/firebase_storage.dart' as _i3;
import 'package:happ_eats/models/dish.dart' as _i7;
import 'package:happ_eats/models/user.dart' as _i5;
import 'package:happ_eats/services/auth_service.dart' as _i4;
import 'package:happ_eats/services/file_service.dart' as _i9;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i11;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseFirestore_0 extends _i1.SmartFake
    implements _i2.FirebaseFirestore {
  _FakeFirebaseFirestore_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWriteBatch_1 extends _i1.SmartFake implements _i2.WriteBatch {
  _FakeWriteBatch_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDocumentSnapshot_2<T extends Object?> extends _i1.SmartFake
    implements _i2.DocumentSnapshot<T> {
  _FakeDocumentSnapshot_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQuerySnapshot_3<T extends Object?> extends _i1.SmartFake
    implements _i2.QuerySnapshot<T> {
  _FakeQuerySnapshot_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseStorage_4 extends _i1.SmartFake
    implements _i3.FirebaseStorage {
  _FakeFirebaseStorage_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAuthService_5 extends _i1.SmartFake implements _i4.AuthService {
  _FakeAuthService_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserModel_6 extends _i1.SmartFake implements _i5.UserModel {
  _FakeUserModel_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseAuth_7 extends _i1.SmartFake implements _i6.FirebaseAuth {
  _FakeFirebaseAuth_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserCredential_8 extends _i1.SmartFake
    implements _i6.UserCredential {
  _FakeUserCredential_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DishRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockDishRepository extends _i1.Mock implements _i7.DishRepository {
  @override
  _i2.FirebaseFirestore get db => (super.noSuchMethod(
        Invocation.getter(#db),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#db),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#db),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i8.Future<_i2.WriteBatch> createDish(
    _i2.WriteBatch? batch,
    String? id,
    String? user,
    String? dishName,
    String? description,
    Map<String, dynamic>? nutritionalInfo,
    String? imageName,
    Map<String, dynamic>? ingredientes,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createDish,
          [
            batch,
            id,
            user,
            dishName,
            description,
            nutritionalInfo,
            imageName,
            ingredientes,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #createDish,
            [
              batch,
              id,
              user,
              dishName,
              description,
              nutritionalInfo,
              imageName,
              ingredientes,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #createDish,
            [
              batch,
              id,
              user,
              dishName,
              description,
              nutritionalInfo,
              imageName,
              ingredientes,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Future<_i2.WriteBatch> deleteDish(
    _i2.WriteBatch? batch,
    String? uid,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteDish,
          [
            batch,
            uid,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #deleteDish,
            [
              batch,
              uid,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #deleteDish,
            [
              batch,
              uid,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Stream<_i2.QuerySnapshot<Map<String, dynamic>>> getAllDishes(
    int? amount,
    String? id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllDishes,
          [
            amount,
            id,
          ],
        ),
        returnValue:
            _i8.Stream<_i2.QuerySnapshot<Map<String, dynamic>>>.empty(),
        returnValueForMissingStub:
            _i8.Stream<_i2.QuerySnapshot<Map<String, dynamic>>>.empty(),
      ) as _i8.Stream<_i2.QuerySnapshot<Map<String, dynamic>>>);

  @override
  _i8.Future<_i2.DocumentSnapshot<Map<String, dynamic>>> getDish(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDish,
          [id],
        ),
        returnValue:
            _i8.Future<_i2.DocumentSnapshot<Map<String, dynamic>>>.value(
                _FakeDocumentSnapshot_2<Map<String, dynamic>>(
          this,
          Invocation.method(
            #getDish,
            [id],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.DocumentSnapshot<Map<String, dynamic>>>.value(
                _FakeDocumentSnapshot_2<Map<String, dynamic>>(
          this,
          Invocation.method(
            #getDish,
            [id],
          ),
        )),
      ) as _i8.Future<_i2.DocumentSnapshot<Map<String, dynamic>>>);

  @override
  _i8.Future<_i2.QuerySnapshot<Map<String, dynamic>>> getAllDishesFuture(
          String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllDishesFuture,
          [id],
        ),
        returnValue: _i8.Future<_i2.QuerySnapshot<Map<String, dynamic>>>.value(
            _FakeQuerySnapshot_3<Map<String, dynamic>>(
          this,
          Invocation.method(
            #getAllDishesFuture,
            [id],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.QuerySnapshot<Map<String, dynamic>>>.value(
                _FakeQuerySnapshot_3<Map<String, dynamic>>(
          this,
          Invocation.method(
            #getAllDishesFuture,
            [id],
          ),
        )),
      ) as _i8.Future<_i2.QuerySnapshot<Map<String, dynamic>>>);
}

/// A class which mocks [FileService].
///
/// See the documentation for Mockito's code generation for more information.
class MockFileService extends _i1.Mock implements _i9.FileService {
  @override
  _i3.FirebaseStorage get storage => (super.noSuchMethod(
        Invocation.getter(#storage),
        returnValue: _FakeFirebaseStorage_4(
          this,
          Invocation.getter(#storage),
        ),
        returnValueForMissingStub: _FakeFirebaseStorage_4(
          this,
          Invocation.getter(#storage),
        ),
      ) as _i3.FirebaseStorage);

  @override
  _i4.AuthService get auth => (super.noSuchMethod(
        Invocation.getter(#auth),
        returnValue: _FakeAuthService_5(
          this,
          Invocation.getter(#auth),
        ),
        returnValueForMissingStub: _FakeAuthService_5(
          this,
          Invocation.getter(#auth),
        ),
      ) as _i4.AuthService);

  @override
  _i8.Future<_i10.FilePickerResult?> getImageFile() => (super.noSuchMethod(
        Invocation.method(
          #getImageFile,
          [],
        ),
        returnValue: _i8.Future<_i10.FilePickerResult?>.value(),
        returnValueForMissingStub: _i8.Future<_i10.FilePickerResult?>.value(),
      ) as _i8.Future<_i10.FilePickerResult?>);

  @override
  _i8.Future<_i10.FilePickerResult?> getDietFile() => (super.noSuchMethod(
        Invocation.method(
          #getDietFile,
          [],
        ),
        returnValue: _i8.Future<_i10.FilePickerResult?>.value(),
        returnValueForMissingStub: _i8.Future<_i10.FilePickerResult?>.value(),
      ) as _i8.Future<_i10.FilePickerResult?>);

  @override
  String generateRandomString(int? len) => (super.noSuchMethod(
        Invocation.method(
          #generateRandomString,
          [len],
        ),
        returnValue: _i11.dummyValue<String>(
          this,
          Invocation.method(
            #generateRandomString,
            [len],
          ),
        ),
        returnValueForMissingStub: _i11.dummyValue<String>(
          this,
          Invocation.method(
            #generateRandomString,
            [len],
          ),
        ),
      ) as String);

  @override
  _i8.Future<String> uploadImageFile(
    _i10.FilePickerResult? file,
    String? name,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadImageFile,
          [
            file,
            name,
          ],
        ),
        returnValue: _i8.Future<String>.value(_i11.dummyValue<String>(
          this,
          Invocation.method(
            #uploadImageFile,
            [
              file,
              name,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<String>.value(_i11.dummyValue<String>(
          this,
          Invocation.method(
            #uploadImageFile,
            [
              file,
              name,
            ],
          ),
        )),
      ) as _i8.Future<String>);

  @override
  _i8.Future<String?> uploadDietFile(_i10.FilePickerResult? file) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadDietFile,
          [file],
        ),
        returnValue: _i8.Future<String?>.value(),
        returnValueForMissingStub: _i8.Future<String?>.value(),
      ) as _i8.Future<String?>);

  @override
  _i8.Future<String?> downloadDietFile(
    String? fileName,
    String? uid,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #downloadDietFile,
          [
            fileName,
            uid,
          ],
        ),
        returnValue: _i8.Future<String?>.value(),
        returnValueForMissingStub: _i8.Future<String?>.value(),
      ) as _i8.Future<String?>);

  @override
  _i8.Future<String?> deleteFile(String? fileName) => (super.noSuchMethod(
        Invocation.method(
          #deleteFile,
          [fileName],
        ),
        returnValue: _i8.Future<String?>.value(),
        returnValueForMissingStub: _i8.Future<String?>.value(),
      ) as _i8.Future<String?>);

  @override
  _i8.Future<String?> deleteImage(String? url) => (super.noSuchMethod(
        Invocation.method(
          #deleteImage,
          [url],
        ),
        returnValue: _i8.Future<String?>.value(),
        returnValueForMissingStub: _i8.Future<String?>.value(),
      ) as _i8.Future<String?>);
}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i5.UserRepository {
  @override
  _i2.FirebaseFirestore get db => (super.noSuchMethod(
        Invocation.getter(#db),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#db),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#db),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i8.Future<_i2.WriteBatch> createUser(
    _i2.WriteBatch? batch,
    String? uid,
    String? newFirstName,
    String? newLastName,
    String? newTel,
    String? newGender,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createUser,
          [
            batch,
            uid,
            newFirstName,
            newLastName,
            newTel,
            newGender,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #createUser,
            [
              batch,
              uid,
              newFirstName,
              newLastName,
              newTel,
              newGender,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #createUser,
            [
              batch,
              uid,
              newFirstName,
              newLastName,
              newTel,
              newGender,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Future<_i2.WriteBatch> deleteUser(
    _i2.WriteBatch? batch,
    String? uid,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteUser,
          [
            batch,
            uid,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #deleteUser,
            [
              batch,
              uid,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #deleteUser,
            [
              batch,
              uid,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Future<_i2.WriteBatch> updateUserTel(
    _i2.WriteBatch? batch,
    String? uid,
    String? newTel,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserTel,
          [
            batch,
            uid,
            newTel,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #updateUserTel,
            [
              batch,
              uid,
              newTel,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #updateUserTel,
            [
              batch,
              uid,
              newTel,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Future<_i2.WriteBatch> updateUserFirstName(
    _i2.WriteBatch? batch,
    String? uid,
    String? newFirstName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserFirstName,
          [
            batch,
            uid,
            newFirstName,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #updateUserFirstName,
            [
              batch,
              uid,
              newFirstName,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #updateUserFirstName,
            [
              batch,
              uid,
              newFirstName,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Future<_i2.WriteBatch> updateUserLastName(
    _i2.WriteBatch? batch,
    String? uid,
    String? newLastName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserLastName,
          [
            batch,
            uid,
            newLastName,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #updateUserLastName,
            [
              batch,
              uid,
              newLastName,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #updateUserLastName,
            [
              batch,
              uid,
              newLastName,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Future<_i2.WriteBatch> updateUserGender(
    _i2.WriteBatch? batch,
    String? uid,
    String? newGender,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserGender,
          [
            batch,
            uid,
            newGender,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #updateUserGender,
            [
              batch,
              uid,
              newGender,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #updateUserGender,
            [
              batch,
              uid,
              newGender,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Future<_i5.UserModel> getUser(String? uid) => (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [uid],
        ),
        returnValue: _i8.Future<_i5.UserModel>.value(_FakeUserModel_6(
          this,
          Invocation.method(
            #getUser,
            [uid],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i5.UserModel>.value(_FakeUserModel_6(
          this,
          Invocation.method(
            #getUser,
            [uid],
          ),
        )),
      ) as _i8.Future<_i5.UserModel>);

  @override
  _i8.Future<_i2.WriteBatch> addDishes(
    _i2.WriteBatch? batch,
    String? id,
    String? user,
    String? dishName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addDishes,
          [
            batch,
            id,
            user,
            dishName,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #addDishes,
            [
              batch,
              id,
              user,
              dishName,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #addDishes,
            [
              batch,
              id,
              user,
              dishName,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);

  @override
  _i8.Future<_i2.WriteBatch> removeDishes(
    _i2.WriteBatch? batch,
    String? id,
    String? user,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeDishes,
          [
            batch,
            id,
            user,
          ],
        ),
        returnValue: _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #removeDishes,
            [
              batch,
              id,
              user,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #removeDishes,
            [
              batch,
              id,
              user,
            ],
          ),
        )),
      ) as _i8.Future<_i2.WriteBatch>);
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i4.AuthService {
  @override
  _i6.FirebaseAuth get auth => (super.noSuchMethod(
        Invocation.getter(#auth),
        returnValue: _FakeFirebaseAuth_7(
          this,
          Invocation.getter(#auth),
        ),
        returnValueForMissingStub: _FakeFirebaseAuth_7(
          this,
          Invocation.getter(#auth),
        ),
      ) as _i6.FirebaseAuth);

  @override
  _i8.Stream<_i6.User?> authStateChangesStream() => (super.noSuchMethod(
        Invocation.method(
          #authStateChangesStream,
          [],
        ),
        returnValue: _i8.Stream<_i6.User?>.empty(),
        returnValueForMissingStub: _i8.Stream<_i6.User?>.empty(),
      ) as _i8.Stream<_i6.User?>);

  @override
  _i8.Future<_i6.UserCredential> createUser(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createUser,
          [
            email,
            password,
          ],
        ),
        returnValue: _i8.Future<_i6.UserCredential>.value(_FakeUserCredential_8(
          this,
          Invocation.method(
            #createUser,
            [
              email,
              password,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i6.UserCredential>.value(_FakeUserCredential_8(
          this,
          Invocation.method(
            #createUser,
            [
              email,
              password,
            ],
          ),
        )),
      ) as _i8.Future<_i6.UserCredential>);

  @override
  _i8.Future<void> deleteUser(String? uid) => (super.noSuchMethod(
        Invocation.method(
          #deleteUser,
          [uid],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> updateUserEmail(String? newEmail) => (super.noSuchMethod(
        Invocation.method(
          #updateUserEmail,
          [newEmail],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> updateUserPassword(String? newPassword) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserPassword,
          [newPassword],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<_i6.UserCredential> login(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [
            email,
            password,
          ],
        ),
        returnValue: _i8.Future<_i6.UserCredential>.value(_FakeUserCredential_8(
          this,
          Invocation.method(
            #login,
            [
              email,
              password,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i6.UserCredential>.value(_FakeUserCredential_8(
          this,
          Invocation.method(
            #login,
            [
              email,
              password,
            ],
          ),
        )),
      ) as _i8.Future<_i6.UserCredential>);

  @override
  _i8.Future<bool> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
        returnValueForMissingStub: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);
}
