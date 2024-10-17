import 'package:btp/helper/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';

class Database {
  Database();

  static late MySQLConnection conn;


  static Future<void> setupconnection() async {
    print("Connecting to mysql server...");
    String host = dotenv.env['DATABASE_HOST']!;
    int port = int.parse(dotenv.env['DATABASE_PORT']!);
    String userName = dotenv.env['DATABASE_USERNAME']!;
    String password = dotenv.env['DATABASE_PASSWORD']!;
    String databaseName = dotenv.env['DATABASE_NAME']!;
    // create connection
    conn = await MySQLConnection.createConnection(
        host: host,
        port: port,
        userName: userName,
        password: password,
        databaseName: databaseName,
        secure: false
    );

    print("this place");
    await conn.connect();
    print("Connected");
  }

  static Future<void> uploadData({required String rollNum, required String name, required BuildContext context}) async {
    try{
      await setupconnection();

      await conn.execute(
        "INSERT INTO Student (rollnum, name) VALUES (:rollnum, :name)",
        {
          "rollnum": rollNum,
          "name": name,
        },
      );
      // print('here');
      Messenger.showSnackBar(context: context, message: 'Data successfully inserted');
      await conn.close();
      // print("here2");
    }
    catch(e){
      // Messenger.showSnackBar(context: context, message: "Database can not be connected");

    }


  }

  static Future<String> deleteData(BuildContext context, String rollNum) async {
    String responseMessage = "Student with roll number $rollNum does not exist";
    try{
      await setupconnection();

      var result = await conn.execute("SELECT name FROM Student WHERE rollnum = '$rollNum' LIMIT 1");

        // Default message


      if (result.numOfRows > 0) {
        var deleteResult = await conn.execute("DELETE FROM Student WHERE rollnum = '$rollNum'");

        if (deleteResult.affectedRows.toInt() > 0) {
          responseMessage = "Student with roll number $rollNum has been deleted successfully";
        } else {
          responseMessage = "Failed to delete student with roll number $rollNum";
        }
      }

      await conn.close();

    }
    catch(e){
      responseMessage = "Error occurred. Please try again";
    }


    Messenger.showSnackBar(context: context, message: responseMessage);
    // print(responseMessage);
    return responseMessage;
  }

  static Future<String?> getData(BuildContext context, String rollNum) async {
    String? studentName;
    bool flag = true;
    String responseMessage = "No student found with roll number: $rollNum";
    try{
      await setupconnection();

      var result = await conn.execute("SELECT name FROM Student WHERE rollnum = '$rollNum' LIMIT 1");

      if (result.numOfRows > 0) {
        studentName = result.rows.first.colAt(0)!;
        flag = false;
      }

      await conn.close();
    }
    catch(e){
      responseMessage = "Error occurred. Please try again";
    }
    


    if(flag){
      Messenger.showSnackBar(context: context, message: responseMessage);
    }

    // print(studentName);
    return studentName;
  }

}