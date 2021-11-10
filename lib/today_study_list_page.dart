import 'package:flutter/material.dart';
import 'package:flutter_app/today_study_list_widget.dart';


class TodayStudyListPage extends StatefulWidget{
  const TodayStudyListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayStudyListPageState();


}

class _TodayStudyListPageState extends State<TodayStudyListPage>{
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("오늘의 공부 목록"),
        centerTitle: true,
      ),
      body: TodayStudyListWidget(),
    );
  }

}