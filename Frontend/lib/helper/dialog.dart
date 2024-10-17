import 'package:btp/controller/database.dart';
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

  static void showSnackBar({ required BuildContext context, required String message}) {
    // Use ScaffoldMessenger.of(context) instead of GlobalKey
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Optional: Customize duration
      ),
    );
  }


  static void showInsertDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController rollNumController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Insert Student Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: rollNumController,
                decoration: InputDecoration(labelText: 'Roll Number'),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && rollNumController.text.isNotEmpty) {
                  await Database.uploadData(context: context, name: nameController.text, rollNum: rollNumController.text);
                  Navigator.of(context).pop();
                } else {
                  showSnackBar(context: context, message:'Please fill in both fields');
                }
              },
              child: Text('Insert'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  static void showGetDialog(BuildContext context) {
    final TextEditingController rollNumController = TextEditingController();
    String? name;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Get Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: rollNumController,
                decoration: InputDecoration(labelText: 'Roll Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (rollNumController.text.isNotEmpty) {
                  name = await Database.getData(context, rollNumController.text.toString());
                  Navigator.of(context).pop();
                  if(name != null){
                    showPopUp(context: context, title: 'Information', message: "The name of student whose Roll Number is ${rollNumController.text} is $name");
                  }
                } else {
                  showSnackBar(context: context, message: 'Please fill in both fields');
                }
              },
              child: Text('Get'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  static void showDeleteDialog(BuildContext context) {
    final TextEditingController rollNumController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: rollNumController,
                decoration: InputDecoration(labelText: 'Roll Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (rollNumController.text.isNotEmpty) {
                  await Database.deleteData(context, rollNumController.text.toString());
                  Navigator.of(context).pop();
                } else {
                  showSnackBar(context: context, message: 'Please fill in both fields');
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}