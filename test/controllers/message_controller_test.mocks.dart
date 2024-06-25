// Mocks generated by Mockito 5.4.4 from annotations
// in happ_eats/test/controllers/message_controller_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:happ_eats/models/message.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

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

/// A class which mocks [MessageRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMessageRepository extends _i1.Mock implements _i3.MessageRepository {
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
  _i4.Stream<_i2.QuerySnapshot<Object?>?> getMessagesForAmount(
    int? amount,
    String? uid,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMessagesForAmount,
          [
            amount,
            uid,
          ],
        ),
        returnValue: _i4.Stream<_i2.QuerySnapshot<Object?>?>.empty(),
        returnValueForMissingStub:
            _i4.Stream<_i2.QuerySnapshot<Object?>?>.empty(),
      ) as _i4.Stream<_i2.QuerySnapshot<Object?>?>);

  @override
  _i4.Future<_i2.WriteBatch> sendMessage(
    _i2.WriteBatch? batch,
    String? uid,
    String? toID,
    String? fromID,
    String? text,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendMessage,
          [
            batch,
            uid,
            toID,
            fromID,
            text,
          ],
        ),
        returnValue: _i4.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #sendMessage,
            [
              batch,
              uid,
              toID,
              fromID,
              text,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #sendMessage,
            [
              batch,
              uid,
              toID,
              fromID,
              text,
            ],
          ),
        )),
      ) as _i4.Future<_i2.WriteBatch>);

  @override
  _i4.Future<_i2.WriteBatch> deleteAllUserMessages(
    _i2.WriteBatch? batch,
    String? uid,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteAllUserMessages,
          [
            batch,
            uid,
          ],
        ),
        returnValue: _i4.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #deleteAllUserMessages,
            [
              batch,
              uid,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.WriteBatch>.value(_FakeWriteBatch_1(
          this,
          Invocation.method(
            #deleteAllUserMessages,
            [
              batch,
              uid,
            ],
          ),
        )),
      ) as _i4.Future<_i2.WriteBatch>);
}
