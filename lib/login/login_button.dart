import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../b_navi_bar.dart';
import '../transport_util.dart';

class LoginButton extends StatelessWidget{
  final TextEditingController idController;
  final TextEditingController passwordController;
  const LoginButton({Key? key,required this.idController,required this.passwordController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextButton(
      onPressed: () async {
        var pref = await SharedPreferences.getInstance();
        String id = idController.text;
        String password = passwordController.text;
        if(id=="" ){
          Fluttertoast.showToast(msg: "아이디를 입력해주세요.");
          return;
        }else if(password== ""){
          Fluttertoast.showToast(msg: "비밀번호를 입력해주세요");
          return;
        }
        Map<String,dynamic> ret = await login(id,password);
        print(ret);
        if(ret['success']=="FAIL"){
          Fluttertoast.showToast(msg: "로그인에 실패했습니다. 아이디나 비밀번호를 확인해주세요.");
          return;
        }else if(ret['success']=="error"){
          Fluttertoast.showToast(msg: "알 수 없는 이유로 로그인에 실패했습니다. 인터넷 연결을 확인해보세요.");
          return;
        }
        pref.setString("jwtToken", ret['token']);
        pref.setInt("uid", ret['uid']);
        Fluttertoast.showToast(msg: "로그인에 성공했습니다.");
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) =>Scaffold(body: BtnNaviBar())),(route)=>false);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text("로그인",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.bold ),),
        ),
      ),
    );
  }
}