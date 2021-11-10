import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class StudyRecordWidget extends StatefulWidget{
  const StudyRecordWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StudyRecordWidgetState();


}

class _StudyRecordWidgetState extends State<StudyRecordWidget>{
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget _buildCalaendar(){
    return TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime(2020),
        lastDay: DateTime(2030),
      headerStyle:const HeaderStyle(
          headerMargin: EdgeInsets.only(left: 40, top: 10, right: 40, bottom: 10),
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.arrow_left,size: 40),
          rightChevronIcon: Icon(Icons.arrow_right,size: 40),
          titleTextStyle: TextStyle(fontSize: 17.0)
      ),
      onDaySelected: (DateTime selectedDay, DateTime focusedDay){
          setState((){
            _selectedDay=selectedDay;
            _focusedDay = focusedDay;
          });
          print(_focusedDay);
      },
      calendarStyle: const CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white)
      ),
      selectedDayPredicate: (DateTime date){
          return isSameDay(_selectedDay, date);
      },

    );
  }
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title : const Text("나의 공부 기록"),centerTitle: true),
      body: _buildCalaendar(),
    );
  }

}