import 'package:firebase_auth/firebase_auth.dart';



class AuthService{

  final FirebaseAuth auth;

  AuthService({required this.auth});

  /// Returns a User object with the information
   User? getCurrentUser()  {
    return auth.currentUser;
  }

  /// Returns a stream for the auth changes
   Stream<User?> authStateChangesStream() {
    return auth.authStateChanges();
  }

  /// Creates a user in firebase auth
  /// Requires an email and password
  /// Returns a UserCredential
   Future<UserCredential> createUser(String email, String password) async {

     UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
     return result;
  }

  /// Deletes a user in firebase auth
  /// Requires a uid
   Future<void> deleteUser(String uid) async {
    return auth.currentUser!.delete();
  }

  /// Updates a user's email in firebase auth
  /// Requires a uid
   Future<void> updateUserEmail(String newEmail) async {
    return auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
  }

  /// Updates a user's password in firebase auth
  /// Requires a uid
   Future<void> updateUserPassword(String newPassword) async {

    return auth.currentUser!.updatePassword(newPassword);
  }

  /// Logs in a user
  /// Requires am email and password
  /// Returns a UserCredential object
   Future<UserCredential> login(String email, String password) async {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Logs out a user
  /// Returns a bool
   Future<bool> logout() async {
    auth.signOut();
    if (auth.currentUser == null)
    {
      return true;
    }
    else {
      return false;
    }
  }

}