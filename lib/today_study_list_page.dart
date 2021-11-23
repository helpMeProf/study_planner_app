import 'package:flutter/material.dart';
import 'package:flutter_app/login/login_page.dart';
import 'package:flutter_app/today_study_list_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TodayStudyListPage extends StatefulWidget{
  const TodayStudyListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayStudyListPageState();


}

class _TodayStudyListPageState extends State<TodayStudyListPage>{
  late String userName;
  late SharedPreferences pref;
  Future<void> _loadUserName() async{
    pref = await SharedPreferences.getInstance();
    userName = pref.getString("name")!;
  }
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("오늘의 공부 목록"),
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
      body: TodayStudyListWidget()
    );
  }

}