import 'package:flutter/material.dart';
import 'package:flutter_app/camera_page.dart';
import 'package:flutter_app/transport_util.dart';

class TodayStudyListWidget extends StatefulWidget{
  const TodayStudyListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayStudyListWidgetState();


}
class _TodayStudyListWidgetState extends State<TodayStudyListWidget>{
  final TextEditingController _textEditingController = TextEditingController();
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
                          
                        }
                    ),
                    hintText: '추가할 과목을 입력하세요',
                  ),
                ),
              ),
              FutureBuilder<List<Map<String,dynamic>>>(
                  future: getUserDate('test'),
                  builder: (context,snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blueAccent, width: 1)
                              ),
                              child: ListTile(
                                title: Text('${snapshot.data![index]['subject']} \t ${snapshot
                                    .data![index]['studyTime']}'),
                                trailing: OutlinedButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Camera()),
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
