import 'package:flutter/material.dart';
import 'package:flutter_app/b_navi_bar.dart';
import 'package:flutter_app/login/login_page.dart';
import 'package:flutter_app/transport_util.dart';

import 'package:shared_preferences/shared_preferences.dart';


void main()  {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: "hi",),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState(){
    super.initState();
  }
  Future<bool> _loadUserData() async{
    var pref = await SharedPreferences.getInstance();
    if(pref.containsKey("id") && pref.containsKey("jwtToken")){
      var token = pref.getString("jwtToken");
      bool ret = await tokenCheck(token!);
      if(ret==false) return false;
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      //body: BtnNaviBar(),
      body: FutureBuilder<bool>(
        future: _loadUserData(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return snapshot!.data==true ? BtnNaviBar(

            ):LoginPage();
          }else{
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
