import 'package:flutter/material.dart';
import 'package:flutter_app/login/login_page.dart';
import 'package:flutter_app/member_util.dart';
import 'package:flutter_app/transport_util.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';


class StudyRecordWidget extends StatefulWidget{
  const StudyRecordWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StudyRecordWidgetState();


}

class _StudyRecordWidgetState extends State<StudyRecordWidget>{
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late String userName;
  late SharedPreferences pref;
  @override
  void initState() {
    super.initState();
  }
  Future<void> _loadUserName() async{
    pref = await SharedPreferences.getInstance();
    userName = pref.getString("name")!;
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

  FutureBuilder _studyListView(){
    return FutureBuilder<List<Map<String,dynamic>>>(
        future: getUserData(DateFormat('yyyy-MM-dd').format(_selectedDay)),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return snapshot.data!.isEmpty ?
              Column(
                children: const [
                  Padding(padding: EdgeInsets.symmetric(vertical: 25)),
                  Icon(Icons.warning_amber_rounded,size : 50,color: Colors.grey),
                  Text("불러올 과목이 없습니다. \n혹은 인터넷 연결을 확인해주세요",style: TextStyle(fontSize: 15),)
                ],
              )
                :
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (context,index){
                return Card(
                    child : ListTile(
                      title: Text('${snapshot.data![index]['subject_name']} \t ${snapshot.data![index]['study_time']}'),
                    )
                );
              }
            );
          }else if(snapshot.hasError){
            return Text("오류 발생");
          }
          return CircularProgressIndicator();
        }
    );
  }
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
          title : const Text("나의 공부 기록"),
          centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/avaterImage.png'),
              ),
                accountName: FutureBuilder(
                  future: _loadUserName(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      return Text("${userName} 님");
                    }else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                accountEmail: Text("환영합니다!")
            ),
            ListTile(
              title: Text("로그 아웃"),
              onTap: (){
                pref.clear();
                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>Scaffold(body: LoginPage())),(route)=>false);
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          _buildCalaendar(),
          Expanded(
              child:SingleChildScrollView(
                child: _studyListView()
                ),
              )
        ],
      ),
    );
  }

}