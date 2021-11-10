import 'package:flutter/material.dart';
import 'package:flutter_app/study_record_widget.dart';
import 'package:flutter_app/today_study_list_widget.dart';


class StudyRecordPage extends StatefulWidget{
  const StudyRecordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StudyRecordPageState();


}

class _StudyRecordPageState extends State<StudyRecordPage>{
  @override
  Widget build(context) {
    return StudyRecordWidget();
  }

}