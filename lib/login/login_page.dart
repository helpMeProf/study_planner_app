import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login/login_widget.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();

}
class _LoginPageState extends State<LoginPage>{


  @override
  Widget build(BuildContext context) {
    return LoginWidget();

  }
}