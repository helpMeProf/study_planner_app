import 'package:flutter/material.dart';

class BtnNaviBar extends StatefulWidget {
  const BtnNaviBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BtnNaviBarState();



}
class _BtnNaviBarState extends State<BtnNaviBar>{
  int _selectedIndex = 0;
  @override
  Widget build(context) {
    // TODO: implement build
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey, //Bar의 배경색
      selectedItemColor: Colors.white, //선택된 아이템의 색상
      unselectedItemColor: Colors.white.withOpacity(.30), //선택 안된 아이템의 색상
      selectedFontSize: 16, //선택된 아이템의 폰트사이즈
      unselectedFontSize: 16, //선택 안된 아이템의 폰트사이즈
      currentIndex: _selectedIndex, //현재 선택된 Index
      onTap:(index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: 'Record',
          icon: Icon(Icons.assessment_outlined,size: 30.0),
        ),
        BottomNavigationBarItem(
          label: 'Study',
          icon: Icon(Icons.menu_book,size: 30.0,),
        ),
      ],
    );
  }

}