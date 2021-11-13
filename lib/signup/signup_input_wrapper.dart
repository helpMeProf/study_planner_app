import 'package:flutter/material.dart';
import 'package:flutter_app/login/login_button.dart';
import 'package:flutter_app/signup/signup_input_field.dart';


class SignUpInputWrapper extends StatelessWidget{
  late String id;
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
            child: SignUpInputField(),
          ),
          const SizedBox(height: 40,),
          TextButton(
              onPressed: (){},
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("회원가입",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.bold ),),
                ),
              )
          ),
          const SizedBox(height: 40,),
          //LoginButton()
        ],
      ),
    );
  }
}