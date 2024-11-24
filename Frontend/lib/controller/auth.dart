import 'package:btp/helper/dialog.dart';
import 'package:btp/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthCalls{

  static Future<String?> getUserUID() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid; // Return the user's UID
    }
    return null; // User is not logged in
  }

  static void handleGoogleSignIn({required BuildContext context, required var auth}) async {
    print("yes i am here");
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      await auth.signInWithProvider(_googleAuthProvider);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                auth: auth,
              )));
    } catch (error) {
      // print("sohum is here");
      Messenger.showSnackBar(context: context, message: error.toString());
      print(error);
    }
  }

  static void signout() {
    FirebaseAuth.instance.signOut();
  }
}