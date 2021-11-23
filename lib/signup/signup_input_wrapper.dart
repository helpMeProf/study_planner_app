import 'package:flutter/material.dart';
import 'package:flutter_app/login/login_button.dart';
import 'package:flutter_app/signup/signup_button.dart';
import 'package:flutter_app/signup/signup_input_field.dart';


class SignUpInputWrapper extends StatelessWidget{
  late String id;
  TextEditingController idController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController nameController= TextEditingController();
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
            child: SignUpInputField(idController: idController,passwordController: passwordController,nameController: nameController),
          ),
          const SizedBox(height: 40,),
          SignUpButton(idController: idController, passwordController: passwordController, nameController: nameController)
        ],
      ),
    );
  }
}