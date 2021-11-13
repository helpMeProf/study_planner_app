import 'package:flutter/material.dart';
import 'package:flutter_app/login/login_button.dart';
import 'package:flutter_app/signup/signup_page.dart';

import 'input_field.dart';

class InputWrapper extends StatelessWidget{
  late String id;
  TextEditingController idController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  @override
  Widget build(context){
    return Padding(
        padding: EdgeInsets.all(30),
      child: Column(
        children: [
          const SizedBox(height: 40,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: InputField(idController: idController, passwordController: passwordController),
          ),
          const SizedBox(height: 40,),
          TextButton(
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) =>Scaffold(body: SignUpPage())));
              },
              child: Center(
                  child: Text("회원가입",style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight:FontWeight.bold ),),
              ),
          ),
          const SizedBox(height: 40,),
          LoginButton(idController: idController, passwordController: passwordController,)
        ],
      ),
    );
  }
}