import 'dart:ui';

import 'package:btp/controller/auth.dart';
import 'package:btp/helper/uibox.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // User? _user;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.authStateChanges().listen((event) {
      setState(() {
        // _user = event;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
                radius: 1.5,
              ),
            ),
          ),
          // Glass boxes in the background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Logo in the center
          Positioned(
            top: MediaQuery.of(context).size.height * 0.7,
            left: MediaQuery.of(context).size.height * 0.1,
            child: const Text(
              'Smart Score',
              style: TextStyle(
                fontSize: 35.0,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w900,
                color: Colors.white, // Text color
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            left: MediaQuery.of(context).size.height * 0.09,
            child: Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset('assets/images/lnmiit.png'),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
          // Sign In button at the bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  AuthCalls.handleGoogleSignIn(context: context, auth: auth);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    'Login with Google',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Small floating boxes
          UIHelper.buildFloatingBox(100, 20, 60),
          UIHelper.buildFloatingBox(450, 30, 60),
          UIHelper.buildFloatingBox(300, 0, 40),
          UIHelper.buildFloatingBox(200, 40, 45),
          UIHelper.buildFloatingBox(450, 250, 55),
          UIHelper.buildFloatingBox(200, 300, 35),
          UIHelper.buildFloatingBox(300, 300, 45),
        ],
      ),
    );
  }
}
