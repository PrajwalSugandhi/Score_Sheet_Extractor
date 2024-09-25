import 'dart:convert';
import 'dart:io';
import 'package:btp/controller/image_sender.dart';
import 'package:btp/models/student_data.dart';
import 'package:btp/provider/sheet_details.dart';
import 'package:btp/screen/table_image.dart';
import 'package:btp/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import '../helper/dialog.dart';

class StudentPersonalDetailsPage extends ConsumerStatefulWidget {
  StudentPersonalDetailsPage({super.key});

  @override
  ConsumerState<StudentPersonalDetailsPage> createState() =>
      _StudentPersonalDetailsPageState();
}

class _StudentPersonalDetailsPageState extends ConsumerState<StudentPersonalDetailsPage> {
  late File selected_image;
  bool _loading = false;
  var image;
  late StudentData currStudentData;
  String _picture = "";
  String detectedImage = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}



  Future<void> cropimage() async {
    List<String> pictures;
    try {
      print("got yo first one");
      pictures = await CunningDocumentScanner.getPictures(noOfPages: 1) ?? [];
      print("here");
      if (!mounted) return;

      _picture = pictures[0];

      print('before byte me converted');

      final bytes = await File(_picture).readAsBytes();
      print('byte me converted');
      String base64Image = base64Encode(bytes); // Encode the bytes to Base64
      setState(() {
        detectedImage = base64Image;
      });

    } catch (exception) {
      // Handle exception here
      print("Camera problem");
      print(exception);
    }
  }

  Future<void> imageClick() async {
    try {
      await cropimage();
      print('photo vala tak ho gaya');
      setState(() {
        _loading = true;
      });
      await ImageSender.sendImage(detectedImage: detectedImage, ref: ref);
      print('http request success');
      setState(() {
        _loading = false;
      });
      if(!mounted){
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Cropped()));
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("complete process ki error");
      print(e);
      Messenger.showPopUp(
          context: context,
          title: 'Error',
          message: 'Some Error occurred. Please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 23),
      ),
      body: Container(
        // color: Color(0xff131621),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
            radius: 1.5,
          ),
        ),
        child: Center(
          child: _loading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    onPressed: imageClick,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),
        ),
      ),
    );
  }
}
