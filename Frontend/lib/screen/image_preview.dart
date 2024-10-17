import 'dart:convert';
import 'package:btp/models/student_data.dart';
import 'package:btp/provider/sheet_details.dart';
import 'package:btp/screen/marks_recheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/button.dart';

class ImagePreview extends ConsumerStatefulWidget {
  const ImagePreview({super.key});

  @override
  ConsumerState<ImagePreview> createState() => _CroppedState();
}

class _CroppedState extends ConsumerState<ImagePreview> {
  late StudentData currStudentData;
  @override
  Widget build(BuildContext context) {
    currStudentData = ref.watch(currStudentDetailsProvider);
    return Scaffold(
      backgroundColor: const Color(0xff131621),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Image.memory(base64Decode(currStudentData.image)),
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                    value: 'Retake Image',
                    function: () {
                      Navigator.pop(context);
                    }),
                Button(
                    value: 'Next',
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NumberGridPage()));
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
