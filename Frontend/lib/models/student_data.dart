import 'package:flutter/material.dart';

class StudentData{
  late String rollnum;
  late String name;
  List<String> questionMarks = List<String>.filled(11, '0');
  late String totalMarks;
  late var image;

  StudentData({required this.rollnum, required this.name, required this.questionMarks, required this.totalMarks});

  StudentData.defaultCons(){
    rollnum = "NULL";
    name = "NULL";
    totalMarks = "0";
    image = "";
  }

  StudentData.mapToClass(Map<dynamic, dynamic> data){
    rollnum = data['rollnum'];
    var tr = 0;
    for(var i = 1; i < data.length - 2; i++){
      questionMarks[i] = data['$i'].toString();
      tr++;
    }
    totalMarks = data['${tr+1}'].toString();
    image = data['image'];
  }

  void updateData(List<TextEditingController> controllers, TextEditingController nameController){
    rollnum = controllers[0].text.toString();
    name = nameController.text.toString();
    for(var i = 1; i< 11; i++){
      questionMarks[i] = controllers[i].text.toString();
    }
    totalMarks = controllers[11].text.toString();
  }
}