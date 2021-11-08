import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/b_navi_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './camera_page.dart';

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
    _loadUserData();
  }
  _loadUserData() async{
    var pref = await SharedPreferences.getInstance();
    if(!pref.containsKey("uid")){
      pref.setInt("uid", 1);
    }
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: BtnNaviBar(),
    );
  }
}
