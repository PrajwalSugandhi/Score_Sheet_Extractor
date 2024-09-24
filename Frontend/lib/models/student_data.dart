class StudentData{
  late String rollnum;
  late String name;
  List<String> questionMarks = List<String>.filled(11, '0');
  late String totalMarks;

  StudentData({required this.rollnum, required this.name, required this.questionMarks, required this.totalMarks});

  StudentData.defaultcons(){
    rollnum = "NULL";
    name = "NULL";
    totalMarks = "0";
  }
}