import 'package:btp/controller/excel_operations.dart';
import 'package:btp/helper/dialog.dart';
import 'package:btp/models/common_details.dart';
import 'package:btp/models/student_data.dart';
import 'package:btp/provider/sheet_details.dart';
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
  final List<TextEditingController> controllers =
      List.generate(12, (index) => TextEditingController());
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
  }

  updateDetails(){
    currStudentDetails.updateData(controllers);
    ref.read(studentDetailsProvider.notifier).addStudent(data: currStudentDetails);
  }

  void takeMoreImage() {
    updateDetails();
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  @override
  Widget build(BuildContext context) {
    commonDetails = ref.watch(commonDetailsProvider);
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
              children: List.generate(12, (index) {
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
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xff131621),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: takeMoreImage,
                child: const Text(
                  'Add More Image',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
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
                },
                child: const Text(
                  'Add to Excel',
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
