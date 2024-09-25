import 'dart:core';
import 'package:btp/models/student_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/common_details.dart';


class CommonDetailsNotifier extends StateNotifier<Details>{
  CommonDetailsNotifier() : super(Details.defaultcon());

  void updateDetails({required details}){
      state = details;
  }

  void removeDetails(){
    state = Details.defaultcon();
  }
}


final commonDetailsProvider = StateNotifierProvider<CommonDetailsNotifier,Details >( (ref) => CommonDetailsNotifier());


class StudentDetailsNotifier extends StateNotifier<List<StudentData>>{
  StudentDetailsNotifier() : super([]);

  void addStudent({required data}){
    state = [...state, data];
  }

  void deleteAll(){
    state = [];
  }

  void showAll(){
    print(state);
  }
}


final studentDetailsProvider = StateNotifierProvider<StudentDetailsNotifier,List<StudentData>>( (ref) => StudentDetailsNotifier());



class CurrStudentDetailsNotifier extends StateNotifier<StudentData>{
  CurrStudentDetailsNotifier() : super(StudentData.defaultCons());

  void updateStudent({required data}){
    state = data;
  }

  void delete(){
    state = StudentData.defaultCons();
  }
}


final currStudentDetailsProvider = StateNotifierProvider<CurrStudentDetailsNotifier,StudentData>( (ref) => CurrStudentDetailsNotifier());



