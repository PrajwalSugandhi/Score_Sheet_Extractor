import 'dart:convert';
import 'dart:io';
import 'package:btp/models/button.dart';
import 'package:btp/models/textfield.dart';
import 'package:btp/screen/cropped_image.dart';
import 'package:btp/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class StudentPersonalDetailsPage extends StatefulWidget {
  String selectedSubject;
  String selectedTerm;
  String selectedExam;

  StudentPersonalDetailsPage(
      {required this.selectedExam,
      required this.selectedSubject,
      required this.selectedTerm,
      super.key});

  @override
  State<StudentPersonalDetailsPage> createState() =>
      _StudentPersonalDetailsPageState();
}

class _StudentPersonalDetailsPageState
    extends State<StudentPersonalDetailsPage> {
  late File selected_image;
  bool _loading = false;
  var image;
  late Map<dynamic, dynamic> respond;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  Future sendImage() async {
    // final returnedimage = await ImagePicker().pickImage(source: ImageSource.camera);
    // selected_image = File(returnedimage!.path);
    // String base64Image = base64Encode(selected_image.readAsBytesSync());
    setState(() {
      _loading = true;
    });
    String url = 'http://192.168.19.152:5000';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'image': detected_image,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    final Map<dynamic, dynamic> data = json.decode(response.body);

    // print(data);
    // print('StatusCode : ${response.statusCode}');
    // print('Return Data : ${response.body}');
    setState(() {
      respond = data;
    });
    print(respond);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _picture = "";
  String detected_image = "";

  Future<void> cropimage() async {
    List<String> pictures;
    try {
      print("got yo first one");
      pictures = await CunningDocumentScanner.getPictures(noOfPages: 1) ?? [];
      print("here");
      if (!mounted) return;

      // Update the picture path

      _picture = pictures[0];

      print('before byte me converted');
      // Convert the image to Base64
      final bytes = await File(_picture).readAsBytes();
      print('byte me converted');
      String base64Image = base64Encode(bytes); // Encode the bytes to Base64
      setState(() {
        detected_image = base64Image;
      });
      // Log the Base64 string for debugging
      // print("Base64 Image: $base64Image");
    } catch (exception) {
      // Handle exception here
      print("Camera problem");
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 23),
      ),
      body: Container(
        // color: Color(0xff131621),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
            radius: 1.5,
          ),
        ),
        child: Center(
          child: _loading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await cropimage();
                        print('photo vala tak ho gaya');
                        await sendImage();
                        print('http request success');
                        setState(() {
                          _loading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cropped(
                                    str: respond,
                                    selectedExam: widget.selectedExam,
                                    selectedSubject: widget.selectedSubject,
                                    selectedTerm: widget.selectedTerm)));
                      } catch (e) {
                        setState(() {
                          _loading = false;
                        });
                        _showErrorDialog(
                            'Some Error occurred. Please try again');
                      }
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take Photo'),
                  ),
                ),
        ),
      ),
    );
  }
}
