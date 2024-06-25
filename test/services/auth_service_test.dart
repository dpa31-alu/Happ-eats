import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:happ_eats/services/auth_service.dart';
import 'package:test/test.dart';


import 'package:mock_exceptions/mock_exceptions.dart';

void main() {

  group('Test Auth', ()  {

    test('User can sign in with user and password', () async {
      MockFirebaseAuth _auth = MockFirebaseAuth();
      AuthService a = AuthService(auth: _auth);

      a.createUser('wa@wa.com', '123456789');

      expect(_auth.currentUser, isNotNull);


    });

    test('User cannot sign in with user and password if an equal email already exists', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
      );
      MockFirebaseAuth auth = MockFirebaseAuth(mockUser: user);
      AuthService a = AuthService(auth: auth);
      whenCalling(Invocation.method(#createUserWithEmailAndPassword,  null, {#email: contains('wa@wa.com'), #password: contains('123456789')}))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'bla'));
      expect(
            () => a.createUser('wa@wa.com', '123456789'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('CurrentUser returs user object', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
      );
      MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);

      String? result = a.getCurrentUser()!.email;
      expect(
            result , 'wa@wa.com'
      );
    });

    test('CurrentUser returns null if not signed in', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
      );
      MockFirebaseAuth auth = MockFirebaseAuth( mockUser: user);
      AuthService a = AuthService(auth: auth);

      User? result = a.getCurrentUser();
      expect(
          result , null
      );
    });

    test('AuthStateChanges returns a stream with null if signed out', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
      );
      MockFirebaseAuth auth = MockFirebaseAuth( mockUser: user);
      AuthService a = AuthService(auth: auth);

      Stream<User?> result = a.authStateChangesStream();

      expect(
        result, emits(null)
      );
    });

    test('AuthStateChanges returns a stream with User if signed in', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
      );
      MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);

      Stream<User?> result = a.authStateChangesStream();

      expect(
          result, emitsInOrder([isA<User>()])
      );
    });

    test('Login throws exception if credentials incorrect', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
      );

      MockFirebaseAuth auth = MockFirebaseAuth(mockUser: user);
      AuthService a = AuthService(auth: auth);
      whenCalling(Invocation.method(#signInWithEmailAndPassword,  null, {#email: contains('wa@wa.com'), #password: contains('123456789')}))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'bla'));
      expect(
            () => a.login('wa@wa.com', '123456789'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('Login correctly logs a user', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
      );
      MockFirebaseAuth auth = MockFirebaseAuth(mockUser: user);
      AuthService a = AuthService(auth: auth);
      expect(
             a.login('wa@wa.com', '123456789'),
        isA<Future<UserCredential>>()
      );
    });

    test('Logout correctly logs out user, returns true', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
      );
      MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);
      expect(
          await a.logout(),
          true
      );
    });

    test('User can be correctly deleted', () async {
      final user = MockUser(
        isAnonymous: false,
        email: 'wa@wa.com',
        uid: '11'
      );
      MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);

      expect(
          () => a.deleteUser(auth.currentUser!.uid),
          returnsNormally
      );
    });

    test('Deletion can throw exception', () async {
      final user = MockUser(
          isAnonymous: false,
          email: 'wa@wa.com',
          uid: '11'
      );

      whenCalling(Invocation.method(#delete, null))
          .on(user)
          .thenThrow(FirebaseAuthException(code: 'bla'));

      MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);

      expect(
              () => a.deleteUser(auth.currentUser!.uid),
          throwsA(isA<FirebaseAuthException>())
      );
    });

    test('updateUserPassword works', () async {

      final user = MockUser(
          isAnonymous: false,
          email: 'wa@wa.com',
          uid: '11'
      );

      final auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);

      expect(
            () => a.updateUserPassword('newPassword'),
        returnsNormally,
      );
    });

    test('updateUserPassword can throw exception', () async {

      final user = MockUser(
          isAnonymous: false,
          email: 'wa@wa.com',
          uid: '11'
      );


      final auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);

      whenCalling(Invocation.method(#updatePassword, null))
          .on(user)
          .thenThrow(FirebaseAuthException(code: 'weak-password'));

      expect(
            () => a.updateUserPassword('newPassword'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    /*
    test('updateUserEmail works', () async {

      final user = MockUser(
          isAnonymous: false,
          email: 'wa@wa.com',
          uid: '11'
      );

      final auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);


      user.verifyBeforeUpdateEmail('newEmail', null);

      expect(
            () => user.verifyBeforeUpdateEmail('newEmail', null),
        returnsNormally,
      );
    });

    test('updateUSerEmail can throw exception', () async {

      final user = MockUser(
          isAnonymous: false,
          email: 'wa@wa.com',
          uid: '11'
      );


      final auth = MockFirebaseAuth(signedIn: true, mockUser: user);
      AuthService a = AuthService(auth: auth);

      whenCalling(Invocation.method(#updatePassword, null))
          .on(user)
          .thenThrow(FirebaseAuthException(code: 'weak-password'));

      expect(
            () => a.updateUserPassword('newPassword'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
*/


  });
}