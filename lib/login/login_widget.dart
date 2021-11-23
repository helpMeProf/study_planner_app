import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login/input_wrapper.dart';
import 'package:flutter_app/login/login_header.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();

}

class _LoginWidgetState extends State<LoginWidget> {


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
                LoginHeader(),
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
                  child : InputWrapper(),
                ),
                SizedBox(height: 200,),
              ],
            ),
        )

    );
  }
}