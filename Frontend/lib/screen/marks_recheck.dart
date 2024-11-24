import 'dart:async';

import 'package:btp/controller/database.dart';
import 'package:btp/controller/excel_operations.dart';
import 'package:btp/helper/dialog.dart';
import 'package:btp/models/common_details.dart';
import 'package:btp/models/student_data.dart';
import 'package:btp/provider/sheet_details.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberGridPage extends ConsumerStatefulWidget {
  NumberGridPage({super.key});

  @override
  ConsumerState<NumberGridPage> createState() => _NumberGridPageState();
}

class _NumberGridPageState extends ConsumerState<NumberGridPage> {
  late StudentData currStudentDetails;
  late Details commonDetails;
  Excel? excel;
  final List<TextEditingController> controllers =
      List.generate(12, (index) => TextEditingController());
  TextEditingController nameController = TextEditingController();
  List<String> textshown = [
    'Roll Number',
    'Q1',
    'Q2',
    'Q3',
    'Q4',
    'Q5',
    'Q6',
    'Q7',
    'Q8',
    'Q9',
    'Q10',
    'Total Marks'
  ];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 12; i++) {
      controllers[i].text = "Loading";
    }
  }
  Timer? _debounce;

  Future<void> _onTextChanged(String rollNum) async {
    print("debouncing one is called");

    // Cancel any existing timer
    _debounce?.cancel();

    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        // Attempt to get data from database
        final name = await Database.getData(context, rollNum);

        // Update the name controller in the main thread
        setState(() {
          nameController.text = name ?? "Not Found";
        });
      } catch (e) {
        // Handle any errors
        setState(() {
          nameController.text = "Not Found";
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    currStudentDetails = ref.watch(currStudentDetailsProvider);
    commonDetails = ref.watch(commonDetailsProvider);

    controllers[0].text = currStudentDetails.rollnum;
    for (var i = 1; i < 11; i++) {
      controllers[i].text = currStudentDetails.questionMarks[i];
    }
    controllers[11].text = currStudentDetails.totalMarks;
    _fetchNameForRollNumber(currStudentDetails.rollnum);
  }

  Future<void> _fetchNameForRollNumber(String rollNum) async {
    try {
      final name = await Database.getData(context, rollNum);
      setState(() {
        nameController.text = name ?? "Not Found";
      });
    } catch (e) {
      setState(() {
        nameController.text = "Not Found";
      });
    }
  }

  updateDetails(){
    currStudentDetails.updateData(controllers,nameController);
    ref.read(studentDetailsProvider.notifier).addStudent(data: currStudentDetails);
  }

  bool updateOldExcel(){
    bool addOperation = true;
    currStudentDetails.updateData(controllers,nameController);
    addOperation = ExcelOperation.updateExcelFile(excel!, currStudentDetails);
    if(addOperation){
      ref.read(uploadedExcelProvider.notifier).updateSheet(data: excel!);
    }
    else{
      Messenger.showPopUp(context: context, title: "Error", message: "RollNumber not found");
    }
    return addOperation;
  }

  void takeMoreImage() {
    bool addOperation = true;
    if(StoredData.curroperation == Operation.createNew){
      updateDetails();
    }
    else{
      addOperation = updateOldExcel();
      if(addOperation == false){
        return;
      }
    }

    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  @override
  Widget build(BuildContext context) {
    commonDetails = ref.watch(commonDetailsProvider);
    excel = ref.watch(uploadedExcelProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 23,
        ),
        title: const Text('Confirm Marks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color(0xff131621),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(StoredData.curroperation == Operation.createNew)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Name',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ...List.generate(12, (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            textshown[index],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: controllers[index],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) {
                            setState(() {
                              if(index == 0){
                                _onTextChanged(value);
                                print("the got data is");
                              }

                            });
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ]
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xff131621),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: (){
                  takeMoreImage();
                },
                child: const Text(
                  'Add More Data',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              // const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if(StoredData.curroperation == Operation.createNew){
                    updateDetails();
                    ExcelOperation.addToExcel(ref);
                    ref.read(studentDetailsProvider.notifier).deleteAll();
                    ref.read(currStudentDetailsProvider.notifier).delete();
                    Messenger.showPopUp(
                      context: context,
                      title: 'Successful',
                      message:
                      'Excel is successfully downloaded in the downloads folder of phone',
                      number: 5,
                    );
                  }
                  else{
                    var addOperation = updateOldExcel();
                    if(addOperation){
                      ExcelOperation.saveOldExcel(excel!);
                      Messenger.showPopUp(
                        context: context,
                        title: 'Successful',
                        message:
                        'Excel is successfully downloaded in the downloads folder of phone',
                        number: 5,
                      );
                    }
                  }
                },
                child: const Text(
                  'Download Excel',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
