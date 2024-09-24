class Details{
  late String subject;
  late String session;
  late String examType;

  Details({required this.session, required this.subject, required this.examType});


  Details.defaultcon(){
    this.subject = "NULL";
    this.session = "NULL";
    this.examType = "NULL";
  }
}