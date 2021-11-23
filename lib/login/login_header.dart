import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Center(
            child: Text("Hello!", style: TextStyle(color: Colors.black54,fontSize: 40,),),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text("스스로 공부시간을 관리해보세요!",style: TextStyle(color: Colors.black54,fontSize: 18),),
          )
        ],
      ),
    );
  }
}