import 'package:flutter/material.dart';
class SignUpInputField extends StatefulWidget{
  final TextEditingController idController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  const SignUpInputField({Key? key, required this.idController, required this.passwordController, required this.nameController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpInputFieldState();

}
class _SignUpInputFieldState extends State<SignUpInputField>{
  bool _isObscure = true;



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
          child: TextField(
            controller: widget.idController,
            decoration: const InputDecoration(
                labelText: "ID",
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
            controller: widget.passwordController,
            obscureText: _isObscure,
            decoration: InputDecoration(
                labelText: "Password",
                hintText: "비밀번호를 입력하세요",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                suffixIcon: IconButton(
                    onPressed: (){
                      setState((){
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                ),
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
            controller: widget.nameController,
            decoration: const InputDecoration(
                labelText: "Name",
                hintText: "이름을 입력하세요",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none
            ),
          ),
        )
      ],
    );
  }
}