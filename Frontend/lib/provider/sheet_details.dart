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
}


final studentDetailsProvider = StateNotifierProvider<StudentDetailsNotifier,List<StudentData>>( (ref) => StudentDetailsNotifier());



