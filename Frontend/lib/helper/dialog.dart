import 'package:flutter/material.dart';

class Messenger{
  static void showPopUp({required BuildContext context, required String title, required String message, int number = 1}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= number);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}