import 'dart:convert';
import 'package:btp/models/student_data.dart';
import 'package:btp/provider/sheet_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


class ImageSender{
  static Future<void> sendImage({required detectedImage, required WidgetRef ref}) async {
    // setState(() {
    //   _loading = true;
    // });
    print('image bhejne vala he');
    String url = 'http://192.168.235.204:5000';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'image': detectedImage,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    final Map<dynamic, dynamic> data = json.decode(response.body);
    final StudentData studentData = StudentData.mapToClass(data);
    print('data aa gaya server se');
    print(data);
    print(studentData.image);
    ref.read(currStudentDetailsProvider.notifier).updateStudent(data: studentData);
    print(data);
  }
}