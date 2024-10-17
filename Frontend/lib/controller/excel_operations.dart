import 'package:btp/models/student_data.dart';
import 'package:btp/provider/sheet_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'filestorage.dart';
import 'dart:typed_data';


class ExcelOperation{

  static void addToExcel(WidgetRef ref) {
    xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];
    final studentList = ref.watch(studentDetailsProvider);
    sheet.getRangeByIndex(1, 1).setText("S. No.");
    sheet.getRangeByIndex(1, 2).setText("Name");
    sheet.getRangeByIndex(1, 3).setText("Roll Number");

    for (var i = 1; i < 11; i++) {
      sheet.getRangeByIndex(1, i + 3).setText('Q $i');
    }
    sheet.getRangeByIndex(1, 14).setText("Total Marks");


    for(var i = 0; i < studentList.length; i++){
      addStudentData(sheet, i+1, studentList[i]);
    }

    saveExcel(workbook, ref);

  }

  static void addStudentData(var sheet, int index, StudentData currStudentDetails){
    var row = index + 1;
    sheet.getRangeByIndex(row, 1).setText("$index.");
    sheet.getRangeByIndex(row, 2).setText(currStudentDetails.name);
    sheet.getRangeByIndex(row, 3).setText(currStudentDetails.rollnum);
    for (var i = 4; i < 14; i++) {
      sheet.getRangeByIndex(row, i).setText(currStudentDetails.questionMarks[i - 3]);
    }
    sheet.getRangeByIndex(row, 14).setText(currStudentDetails.totalMarks);
  }

  static void saveExcel(xcel.Workbook workbook, WidgetRef ref) async {
    final commonDetails = ref.watch(commonDetailsProvider);
    final List<int> bytes = workbook.saveAsStream();
    Uint8List uint8list = Uint8List.fromList(bytes);

    // Save the file
    await FileStorage.writeCounter(uint8list, "${commonDetails.subject}_${commonDetails.session}_${commonDetails.examType}.xlsx");
    workbook.dispose();
  }
}