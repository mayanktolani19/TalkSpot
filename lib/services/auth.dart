import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk_spot/modal/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signInWithGoogle() async {
    try {
      await googleSignIn.signIn();
      return googleSignIn.currentUser.email;
    } catch (e) {
      print(e);
    }
  }

  getUserName() async {
    try {
      return googleSignIn.currentUser.displayName;
    } catch (e) {
      print(e);
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
