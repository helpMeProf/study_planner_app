import 'package:flutter/material.dart';

class InputField extends StatelessWidget{
  final TextEditingController idController;
  final TextEditingController passwordController;
  const InputField({Key? key, required this.idController, required this.passwordController}) : super(key: key);

  @override
  Widget build(context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey)
            ),
          ),
          child:  TextField(
            controller: idController,
            decoration: const InputDecoration(
              hintText: "아이디를 입력하세요",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none
            ),

          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey)
            ),
          ),
          child: TextField(
            controller: passwordController,
            decoration: const InputDecoration(
                hintText: "비밀번호를 입력하세요",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none
            ),
          ),
        )
      ],
    );
  }
}