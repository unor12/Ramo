import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ramo/models/userData.dart';
import 'package:ramo/services/databaseService.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);
  UserData _firebaseUser(User user) {
    return user != null
        ? UserData(uid: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  Stream<UserData> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_firebaseUser);

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserData> signIn({String email, String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print('userfound');
      User user = result.user;
      // if (!user.emailVerified) {
      //   print(user.email + ' is not verified');
      //   return null;
      // }
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //update later with message pop ups or kung ano man da
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e);
      }
      return null;
    }
  }

  Future<UserData> signUp({String email, String password, String name}) async {
    // try {
    //   await _firebaseAuth.createUserWithEmailAndPassword(
    //       email: email, password: password);
    // } catch (e) {
    //   return e.message;
    // }
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('user signed up successfully');
      User user = result.user;
      user.updateProfile(displayName: name); //update name of user in firebase
      // await user.sendEmailVerification();
      // print('email verification sent to ' + user.email);
      await DatabaseService(uid: user.uid).addUserToDatabase(name, email);
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    }
  }

  // Future<void> addUser({String email, String fullName}) async {
  //   CollectionReference users = FirebaseFirestore.instance.collection('Users');
  //   String uid = FirebaseAuth.instance.currentUser.uid;
  //   users
  //       .doc(uid)
  //       .set({
  //         'full name': fullName,
  //         'email': email,
  //         'uid': uid,
  //       })
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }
}
