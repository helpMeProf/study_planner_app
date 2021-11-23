import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Center(
            child: Text("Welcome", style: TextStyle(color: Colors.black54,fontSize: 40,),),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text("회원 가입",style: TextStyle(color: Colors.black54,fontSize: 18),),
          )
        ],
      ),
    );
  }
}