import 'package:firebase_auth/firebase_auth.dart';



class AuthService{

  final FirebaseAuth auth;

  AuthService({required this.auth});

   User? getCurrentUser()  {
    return auth.currentUser;
  }

   Stream<User?> authStateChangesStream() {
    return auth.authStateChanges();
  }

   Future<UserCredential> createUser(String email, String password) async {

     UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
     User? user = result.user;
     return result;
  }

   Future<void> deleteUser(String uid) async {
    return auth.currentUser!.delete();
  }

   Future<void> updateUserEmail(String newEmail) async {
    return auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
  }

   Future<void> updateUserPassword(String newPassword) async {

    return auth.currentUser!.updatePassword(newPassword);
  }

   Future<UserCredential> login(String email, String password) async {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

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