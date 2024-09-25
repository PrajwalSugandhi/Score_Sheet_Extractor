import 'dart:core';
import 'package:btp/helper/dialog.dart';
import 'package:btp/models/common_details.dart';
import 'package:btp/provider/sheet_details.dart';
import 'package:flutter/material.dart';
import 'package:btp/screen/students_details_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}


class _DetailsPageState extends ConsumerState<DetailsPage> {
  final TextEditingController textController = TextEditingController();

  String dropdownValue1 = '2024-25 I';
  String dropdownValue2 = 'Mid-term';
  String selectedSubject = '';
  List<String> termList = ['2024-25 I', '2023-24 II', '2023-24 I'];
  late Details currentDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Exam Details'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 23,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // color: Color(0xff131621),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.black, Color.fromARGB(255, 0, 20, 153)],
            radius: 1.5,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: TextFormField(
                      controller: textController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Text(
                            'Session:',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: dropdownValue1,
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  dropdownValue1 = newValue;
                                }
                              });
                            },
                            dropdownColor: Colors.blue,
                            style: const TextStyle(color: Colors.white),
                            items: termList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Text(
                            'Exam Type:',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: dropdownValue2,
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  dropdownValue2 = newValue;
                                }
                              });
                            },
                            dropdownColor: Colors.blue,
                            style: const TextStyle(color: Colors.white),
                            items: <String>['Mid-term', 'Endterm']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedSubject = textController.text.toString();
                      });
                      if (textController.text.trim().isEmpty) {
                        Messenger.showPopUp(context: context, title: 'Error', message: 'Please fill all the details');
                      } else {
                        currentDetails = Details(session: dropdownValue1, subject: selectedSubject, examType: dropdownValue2);
                        ref.read(commonDetailsProvider.notifier).updateDetails(details: currentDetails);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentPersonalDetailsPage()),
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
