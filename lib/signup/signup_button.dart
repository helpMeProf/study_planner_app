import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../b_navi_bar.dart';
import '../transport_util.dart';

class SignUpButton extends StatelessWidget{
  final TextEditingController idController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  const SignUpButton({Key? key,required this.idController,required this.passwordController,required this.nameController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextButton(
      onPressed: () async {
        String id = idController.text;
        String password = passwordController.text;
        String name = nameController.text;
        if(id=="" ){
          Fluttertoast.showToast(msg: "아이디를 입력해주세요.");
          return;
        }else if(password== ""){
          Fluttertoast.showToast(msg: "비밀번호를 입력해주세요");
          return;
        }else if(name==""){
          Fluttertoast.showToast(msg: "이름을 입력해주세요");
          return;
        }
        int ret = await signup(id,password,name);
        print(ret);
        if(ret==-1){
          Fluttertoast.showToast(msg: "오류가 발생해서 회원가입에 실패했습니다.");
          return;
        }else if(ret==0){
          Fluttertoast.showToast(msg: "이미 존재하는 아이디 입니다.");
          return;
        }
        Fluttertoast.showToast(msg: "회원가입에 성공했습니다!!.");
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: Color(0xFFD09FEF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text("회원가입",style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight:FontWeight.bold ),),
        ),
      ),
    );
  }
}