import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/signup/signup_header.dart';
import 'package:flutter_app/signup/signup_input_wrapper.dart';
import 'package:flutter_app/signup/signup_widget.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignUpPageState();

}
class _SignUpPageState extends State<SignUpPage>{


  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Color(0xFFE4CAF6),
              Color(0xFFF1E3F6),
              Color(0xFFF1E7FA)
            ])
        ),
        child :SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40,),
              SignUpHeader(),
              Container(
                height: 500,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      bottomRight:Radius.circular(60),
                    )
                ),
                child : SignUpInputWrapper(),
              ),
              SizedBox(height: 200,),
            ],
          ),
        )

    );
  }
}