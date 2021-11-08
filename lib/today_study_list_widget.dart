import 'package:flutter/material.dart';
import 'package:flutter_app/camera_page.dart';
import 'package:flutter_app/transport_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodayStudyListWidget extends StatefulWidget{
  const TodayStudyListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayStudyListWidgetState();


}
class _TodayStudyListWidgetState extends State<TodayStudyListWidget>{
  final TextEditingController _textEditingController = TextEditingController();
  void addSubject() async{
    String subject = _textEditingController.value.text;
    if(subject==""){
      Fluttertoast.showToast(msg: "과목이름을 입력해주요!");
    }else{
      var result = await sendUserData(subject);
      setState(() {
        _textEditingController.text='';
      });
      if(result){
        Fluttertoast.showToast(msg: "과목을 등록했습니다!");
      }else{
        Fluttertoast.showToast(msg: "추가에 실패했습니다. 인터넷 연결 혹은 이미 존재하고 있는 과목인지 확인해주세요!",gravity: ToastGravity.TOP);
      }
    }
  }
  @override
  Widget build(context) {
    // TODO: implement build
    return  SingleChildScrollView(
      child:Column(
        children: [
          Column(
            children: [
              Text('오늘의 공부 목록',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.all(20),
                width: 300,
                child:TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(

                    suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed : (){
                          addSubject();
                        }
                    ),
                    hintText: '추가할 과목을 입력하세요',
                  ),
                ),
              ),
              FutureBuilder<List<Map<String,dynamic>>>(
                  future: getUserData('test'),
                  builder: (context,snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.blueAccent, width: 1)
                              ),
                              child: ListTile(
                                title: Text('${snapshot.data![index]['subject_name']} \t ${snapshot
                                    .data![index]['study_time']}'),
                                trailing: OutlinedButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Camera(subjectName :snapshot.data![index]['subject_name'])),
                                    );
                                  },
                                  child: const Text('공부 하기'),
                                ),

                              ),
                            );
                          }
                      );
                    }else if(snapshot.hasError){
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  }
              )

            ],
          ),
        ],
      ),
    );
  }

}
