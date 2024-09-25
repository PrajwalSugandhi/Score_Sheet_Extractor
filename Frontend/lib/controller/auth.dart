import 'package:btp/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthCalls{
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
      print(error);
    }
  }
}