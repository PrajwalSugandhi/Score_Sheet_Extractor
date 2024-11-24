import 'dart:io';

import 'package:btp/models/student_data.dart';
import 'package:btp/provider/sheet_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import 'filestorage.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';


class ExcelOperation{

  static void addToExcel(WidgetRef ref) {
    xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];
    final studentList = ref.watch(studentDetailsProvider);
    sheet.getRangeByIndex(1, 1).setText("S. No.");
    sheet.getRangeByIndex(1, 2).setText("Roll Number");
    sheet.getRangeByIndex(1, 3).setText("Name");
    for (var i = 1; i < 11; i++) {
      sheet.getRangeByIndex(1, i + 3).setText('Q $i');
    }
    sheet.getRangeByIndex(1, 14).setText("Total Marks");


    for(var i = 0; i < studentList.length; i++){
      addStudentData(sheet, i+1, studentList[i]);
    }

    saveNewExcel(workbook, ref);

  }

  static void addStudentData(var sheet, int index, StudentData currStudentDetails){
    var row = index + 1;
    sheet.getRangeByIndex(row, 1).setText("$index.");
    sheet.getRangeByIndex(row, 2).setText(currStudentDetails.rollnum);
    sheet.getRangeByIndex(row, 3).setText(currStudentDetails.name);

    for (var i = 4; i < 14; i++) {
      sheet.getRangeByIndex(row, i).setText(currStudentDetails.questionMarks[i - 3]);
    }
    sheet.getRangeByIndex(row, 14).setText(currStudentDetails.totalMarks);
  }

  static void saveNewExcel(xcel.Workbook workbook, WidgetRef ref) async {
    final commonDetails = ref.watch(commonDetailsProvider);
    final List<int> bytes = workbook.saveAsStream();
    Uint8List uint8list = Uint8List.fromList(bytes);

    // Save the file
    await FileStorage.writeCounter(uint8list, "${commonDetails.subject}_${commonDetails.session}_${commonDetails.examType}.xlsx");
    workbook.dispose();
  }

  static void saveOldExcel(Excel excel) async {

    var newBytes = Uint8List.fromList(excel.encode()!);  // Convert List<int> to Uint8List
    var fileName = StoredData.fileName;
    await FileStorage.writeCounter(newBytes, "${fileName}_(1).xlsx");
  }

  static bool updateExcelFile(Excel excel, StudentData studentDetails) {

      // Step 4: Modify the Excel file (e.g., updating cell A1)
      var sheet = excel.tables.values.first;  // Get the first sheet
      var row = -1;
      for(var i = 0; i < sheet.maxRows; i++){
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i));
        if(cell.value?.toString() == studentDetails.rollnum){
          row = i;
          break;
        }
      }
      if(row == -1){
        return false;
      }

      // var cell = sheet.cell(CellIndex.indexByString('A1'));
      // cell.value = null; // removing any value
      // cell.value = TextCellValue('Some Text');

      var cell;
      for (var i = 3; i < 13; i++) {
        cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: row));
        cell.value = null;
        cell.value = TextCellValue(studentDetails.questionMarks[i - 2]);
        // sheet.getRangeByIndex(row, i).setText();
      }

      cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: row));
      cell.value = null;
      cell.value = TextCellValue(studentDetails.totalMarks);
      return true;
  }
}